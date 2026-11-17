#!/usr/bin/env python3
"""Restore a named BSP layout without restarting apps or sending terminal input."""
import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path

YABAI = shutil.which('yabai') or '/opt/homebrew/bin/yabai'

def yabai(*args):
    result = subprocess.run([YABAI, '-m', *map(str, args)], capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip() or 'Yabai command failed')
    return result.stdout.strip()

def query(kind):
    return json.loads(yabai('query', '--' + kind))

def first(node):
    return node if isinstance(node, str) else first(node['children'][0])

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('layout', nargs='?', default='comms', help='Layout name (default: comms)')
    parser.add_argument('--check', action='store_true', help='Validate matches without moving windows')
    args = parser.parse_args()
    if Path(args.layout).name != args.layout:
        raise RuntimeError('Use a layout name, not a path')
    spec = json.loads(Path(__file__).with_name(args.layout + '.json').read_text())
    displays, spaces, windows = query('displays'), query('spaces'), query('windows')
    display = next((d for d in displays if d['uuid'] == spec['display_uuid']), None)
    if not display:
        raise RuntimeError('Saved monitor is disconnected. No windows changed.')
    candidates = [s for s in spaces if s['display'] == display['index'] and not s['is-native-fullscreen']]
    space = next((s for s in candidates if s['uuid'] == spec['space_uuid']), None)
    if space is None and len(candidates) == 1:
        space = candidates[0]
    if space is None:
        raise RuntimeError('Cannot identify the saved workspace. No windows changed.')
    matched = {}
    for name, rule in spec['windows'].items():
        hits = [w for w in windows if w['app'] == rule['app']
                and w.get('has-ax-reference') and w.get('role') == 'AXWindow'
                and w.get('subrole') == 'AXStandardWindow'
                and (rule.get('title') is None or w['title'] == rule['title'])
                and not (w['app'] == 'Slack' and 'huddle' in w['title'].lower())]
        if len(hits) != 1:
            raise RuntimeError(f'{name}: expected one window, found {len(hits)}. No windows changed.')
        w = hits[0]
        if w['is-minimized'] or w['is-hidden'] or w['is-native-fullscreen']:
            raise RuntimeError(f'{name}: show/unminimize/exit fullscreen first. No windows changed.')
        matched[name] = w
    ids = {w['id'] for w in matched.values()}
    extras = [w for w in windows if w['space'] == space['index'] and w.get('has-ax-reference')
              and w['role'] == 'AXWindow' and not w['is-floating'] and w['id'] not in ids]
    if extras:
        raise RuntimeError('Move extra tiled windows off the destination workspace first: ' +
                           ', '.join(w['app'] + ': ' + w['title'] for w in extras))
    print('Monitor', display['index'], '/ workspace', space['index'])
    for name, w in matched.items():
        print(f"  {name}: {w['app']} — {w['title']} ({w['id']})")
    if args.check:
        print('Checks passed; no windows changed.')
        return
    sid = space['index']
    balance = yabai('config', '--space', sid, 'auto_balance')
    focused = next((w['id'] for w in windows if w['has-focus']), None)
    active = set()
    def win(name, *command):
        return yabai('window', matched[name]['id'], *command)
    def activate(name):
        if name not in active:
            # Yabai reinserts on the focused display; focus this floating window first.
            win(name, '--focus')
            win(name, '--toggle', 'float')
            active.add(name)
    def build(node):
        if isinstance(node, str):
            return
        left, right = node['children']
        anchor, other = first(left), first(right)
        win(anchor, '--insert', 'east' if node['axis'] == 'x' else 'south')
        activate(other)
        win(anchor, '--ratio', 'abs:' + str(node.get('ratio', 0.5)))
        build(left)
        build(right)
    try:
        yabai('config', '--space', sid, 'auto_balance', 'off')
        for name, w in matched.items():
            if w.get('has-fullscreen-zoom'):
                win(name, '--toggle', 'zoom-fullscreen')
            if w.get('has-parent-zoom'):
                win(name, '--toggle', 'zoom-parent')
            if not w['is-floating']:
                win(name, '--toggle', 'float')
            if w['space'] != sid:
                win(name, '--space', sid)
        yabai('space', sid, '--layout', 'bsp')
        for setting, value in spec['settings'].items():
            yabai('config', '--space', sid, setting, value)
        activate(first(spec['tree']))
        build(spec['tree'])
        current = {w['id']: w for w in query('windows')}
        # Verify actual frames against the saved monitor-relative proportions.
        df = display['frame']
        saved = spec['display_frame']
        for name, rule in spec['windows'].items():
            actual = current[matched[name]['id']]['frame']
            expected = rule['frame']
            for key in ('x', 'y', 'w', 'h'):
                scale = df['w'] / saved['w'] if key in ('x', 'w') else df['h'] / saved['h']
                value = expected[key]
                if key in ('x', 'y'):
                    value = df[key] + (value - saved[key]) * scale
                else:
                    value *= scale
                if abs(actual[key] - value) > 5:
                    raise RuntimeError(f'{name}: resulting {key} differs from saved layout; inspect the monitor.')
        print('Restored and verified saved layout.')
    finally:
        # Rejoin any windows left floating if a command failed partway through.
        for name in matched:
            if name not in active:
                try:
                    current = next(w for w in query('windows') if w['id'] == matched[name]['id'])
                    if current['is-floating'] and not matched[name]['is-floating']:
                        win(name, '--toggle', 'float')
                except Exception:
                    pass
        yabai('config', '--space', sid, 'auto_balance', balance)
        if focused:
            try:
                yabai('window', '--focus', focused)
            except RuntimeError:
                pass

if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, OSError, ValueError, KeyError) as exc:
        print('Layout restore stopped:', exc, file=sys.stderr)
        sys.exit(1)
