#!/usr/bin/env python3
"""Restore the Comms workspace; install monitor-aware launch defaults."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import time

YABAI = shutil.which('yabai') or '/opt/homebrew/bin/yabai'
ROOT = Path(__file__).resolve().parent
LABEL = 'Comms'

def yabai(*args):
    p = subprocess.run([YABAI, '-m', *map(str, args)], capture_output=True, text=True, timeout=15)
    if p.returncode:
        raise RuntimeError(p.stderr.strip() or p.stdout.strip() or 'Yabai command failed')
    return p.stdout.strip()

def query(kind):
    return json.loads(yabai('query', '--' + kind))

def optional(*args):
    try:
        return yabai(*args)
    except RuntimeError:
        return None

def workspace_label(mode):
    return LABEL if mode == 'bsp' else 'Comms-portable'

def choose_destination(spec, displays, spaces, portable=False):
    """Select a dedicated workspace without moving existing desktops."""
    preferred = next((d for d in displays if d['uuid'] == spec['display_uuid']), None)
    mode = 'bsp' if preferred and not portable else 'stack'
    target = preferred if mode == 'bsp' else min(displays, key=lambda d: d['index'])
    label = workspace_label(mode)
    normal = [s for s in spaces if not s['is-native-fullscreen']]
    space = next((s for s in normal if s['label'] == label
                  and (mode == 'stack' or s['display'] == target['index'])), None)
    if space is not None and mode == 'stack':
        target = next(d for d in displays if d['index'] == space['display'])
    if space is None:
        uuid = spec.get('space_uuid' if mode == 'bsp' else 'portable_space_uuid')
        candidates = [s for s in normal if s['display'] == target['index']]
        space = next((s for s in candidates if uuid and s['uuid'] == uuid), None)
        if space is None and mode == 'bsp' and len(candidates) == 1 and not candidates[0]['label']:
            space = candidates[0]
        if space is None and mode == 'stack':
            # A newly provisioned empty desktop is safe to adopt, never an occupied one.
            empty = [s for s in candidates if not s['label'] and not s['windows']]
            if empty:
                space = empty[-1]
    return target, space, mode

def destination(spec, check=False, portable=False):
    displays, spaces = query('displays'), query('spaces')
    if not displays:
        raise RuntimeError('No displays available')
    target, space, mode = choose_destination(spec, displays, spaces, portable)
    label = workspace_label(mode)
    if check:
        if space is None:
            raise RuntimeError('Dedicated workspace needs provisioning; add an empty Desktop in Mission Control')
        return target, space, mode
    if space is None:
        raise RuntimeError('Add one empty Desktop in Mission Control on the destination screen, then retry')
    if space['label'] != label:
        for old in spaces:
            if old['label'] == label:
                yabai('space', old['index'], '--label')
        yabai('space', space['index'], '--label', label)
    space = next(s for s in query('spaces') if s['label'] == label)
    return target, space, mode

def match_windows(spec, windows, partial):
    matched = {}
    for name, rule in spec['windows'].items():
        hits = [w for w in windows if w['app'] == rule['app']
                and w.get('has-ax-reference') and w['role'] == 'AXWindow'
                and w['subrole'] == 'AXStandardWindow'
                and (rule.get('title') is None or w['title'] == rule['title'])
                and not (w['app'] == 'Slack' and 'huddle' in w['title'].lower())]
        if not hits and partial:
            continue
        if len(hits) != 1:
            raise RuntimeError(f'{name}: expected one window, found {len(hits)}')
        w = hits[0]
        if w['is-minimized'] or w['is-hidden'] or w['is-native-fullscreen']:
            if partial:
                continue
            raise RuntimeError(f'{name}: show/unminimize/exit fullscreen first')
        matched[name] = w
    return matched

def prune(node, names):
    if isinstance(node, str):
        return node if node in names else None
    children = [prune(n, names) for n in node['children']]
    children = [n for n in children if n is not None]
    if not children:
        return None
    if len(children) == 1:
        return children[0]
    return dict(node, children=children)

def first(node):
    return node if isinstance(node, str) else first(node['children'][0])

def frames(node, rect, gap):
    if isinstance(node, str):
        return {node: rect}
    axis = node['axis']
    position, size = ('x', 'w') if axis == 'x' else ('y', 'h')
    cut = int(rect[size] * node.get('ratio', 0.5))
    a, b = dict(rect), dict(rect)
    a[size] = cut - gap / 2
    b[position] += cut + gap / 2
    b[size] -= cut + gap / 2
    return {**frames(node['children'][0], a, gap), **frames(node['children'][1], b, gap)}

def install(spec, space, script, signals=True):
    for name, rule in spec['windows'].items():
        label = 'comms-' + name
        optional('rule', '--remove', label)
        terms = ['rule', '--add', 'label=' + label,
                 'app=^' + re.escape(rule['app']) + '$',
                 'role=^AXWindow$', 'subrole=^AXStandardWindow$', 'space=' + space['label']]
        if rule.get('title'):
            terms.append('title=^' + re.escape(rule['title']) + '$')
        elif rule['app'] == 'Slack':
            terms.append('title!=.*[Hh]uddle.*')
        yabai(*terms)
    if not signals:
        return
    apps = '^(' + '|'.join(re.escape(r['app']) for r in spec['windows'].values()) + ')$'
    command = '/usr/bin/python3 ' + shlex.quote(str(script)) + ' comms --auto'
    # Ignore move/resize/focus events: restoring must never trigger itself.
    for event in ['window_created', 'window_destroyed', 'window_minimized', 'window_deminimized', 'application_visible', 'application_hidden',
                  'display_added', 'display_removed', 'display_moved', 'display_resized']:
        label = 'comms-' + event
        optional('signal', '--remove', label)
        action = command + (' --window-event' if event in ('window_created', 'window_deminimized') else '')
        action += ' >>' + shlex.quote('/tmp/yabai-comms-' + str(os.getuid()) + '.log') + ' 2>&1'
        terms = ['signal', '--add', 'label=' + label, 'event=' + event, 'action=' + action]
        if not event.startswith('display_'):
            terms.append('app=' + apps)
        yabai(*terms)

def restore(spec, matched, display, space, mode, auto):
    windows = query('windows')
    ids = {w['id'] for w in matched.values()}
    extras = [w for w in windows if w['space'] == space['index'] and w.get('has-ax-reference')
              and w['role'] == 'AXWindow' and not w['is-floating'] and w['id'] not in ids]
    # Hidden/minimized selected apps still belong here, but aren't active tiles.
    inactive = {w['id'] for w in windows if w['is-minimized'] or w['is-hidden']}
    extras = [w for w in extras if w['id'] not in inactive]
    if extras:
        raise RuntimeError('Extra tiled windows in Comms: ' + ', '.join(w['app'] for w in extras))
    if not matched:
        print('No active Comms windows to arrange.')
        return
    sid = space['index']
    label = space['label']
    balance = yabai('config', '--space', sid, 'auto_balance')
    focused = next((w['id'] for w in windows if w['has-focus']), None)
    prior_space = next((s['index'] for s in query('spaces') if s['has-focus']), None)
    active = set()
    floating = set()
    tree = prune(spec['tree'], matched)
    def win(name, *args):
        return yabai('window', matched[name]['id'], *args)
    def activate(name):
        if name not in active:
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
            for key, toggle in [('has-fullscreen-zoom', 'zoom-fullscreen'), ('has-parent-zoom', 'zoom-parent')]:
                if w.get(key):
                    win(name, '--toggle', toggle)
            if not w['is-floating']:
                win(name, '--toggle', 'float')
            floating.add(name)
            if w['space'] != sid:
                win(name, '--space', label)
        yabai('space', label, '--layout', mode)
        for setting, value in spec['settings'].items():
            yabai('config', '--space', sid, setting, value)
        if mode == 'stack':
            for name in matched:
                activate(name)
        else:
            activate(first(tree))
            build(tree)
        # Derive expected geometry from actual display, padding, gap, and menu/Dock
        # reservation rather than scaling old pixel padding to a new screen size.
        # The first window's root union supplies Yabai's usable screen bounds.
        current = {w['id']: w for w in query('windows')}
        actual = [current[w['id']]['frame'] for w in matched.values()]
        x, y = min(f['x'] for f in actual), min(f['y'] for f in actual)
        right = max(f['x'] + f['w'] for f in actual)
        bottom = max(f['y'] + f['h'] for f in actual)
        rect = dict(x=x, y=y, w=right-x, h=bottom-y)
        # Catch wrong-display/stale AX references, not just relative splits.
        df = display['frame']
        if rect['x'] < df['x'] or rect['y'] < df['y'] or right > df['x']+df['w']+2 or bottom > df['y']+df['h']+2:
            raise RuntimeError('Resulting frames extend outside the destination monitor')
        expected = {n: rect for n in matched} if mode == 'stack' else frames(tree, rect, spec['settings']['window_gap'])
        saved = spec['display_frame']
        if mode == 'bsp' and len(matched) == len(spec['windows']) and df['w'] == saved['w'] and df['h'] == saved['h']:
            expected = {}
            for name, rule in spec['windows'].items():
                expected[name] = dict(rule['frame'])
                expected[name]['x'] += df['x'] - saved['x']
                expected[name]['y'] += df['y'] - saved['y']
        for name, w in matched.items():
            got = current[w['id']]
            if got['space'] != sid or got['display'] != display['index']:
                raise RuntimeError(name + ': wrong destination')
            if any(abs(got['frame'][k] - expected[name][k]) > 5 for k in rect):
                raise RuntimeError(name + ': frame differs from saved split; app may enforce a minimum size')
        print(f"Restored and verified {len(matched)} windows on display {display['index']} / {space['label']} ({mode}).")
    finally:
        for name in floating - active:
            try:
                win(name, '--focus')
                win(name, '--toggle', 'float')
            except (RuntimeError, subprocess.TimeoutExpired):
                pass
        yabai('config', '--space', sid, 'auto_balance', balance)
        if focused and optional('window', '--focus', focused) is not None:
            pass
        elif prior_space:
            optional('space', '--focus', prior_space)

def run(args):
    spec = json.loads((ROOT / (args.layout + '.json')).read_text())
    # Preflight matching before provisioning or changing any windows.
    windows = query('windows')
    matched = match_windows(spec, windows, args.auto)
    if args.window_event and os.environ.get('YABAI_WINDOW_ID'):
        event_id = int(os.environ['YABAI_WINDOW_ID'])
        if event_id not in {w['id'] for w in matched.values()}:
            return  # Ignore dialogs, huddles, and other auxiliary windows.
    display, space, mode = destination(spec, args.check, args.portable)
    if args.provision_portable:
        spec['portable_space_uuid'] = space['uuid']
        (ROOT / (args.layout + '.json')).write_text(json.dumps(spec, indent=2) + '\n')
    if args.install:
        install(spec, space, ROOT / 'restore-layout.py')
    if args.check:
        print(f"Matched {len(matched)} windows; destination display {display['index']} / {space['label']} ({mode}). No windows changed.")
        return
    state_file = Path.home() / 'Library/Caches/yabai-comms/last-layout.json'
    state = dict(windows=sorted(w['id'] for w in matched.values()), display=display['uuid'],
                 frame=display['frame'], workspace=space['uuid'], mode=mode)
    if args.auto and not args.install and not args.provision_portable and state_file.exists():
        old = json.loads(state_file.read_text())
        if old == state and all(w['space'] == space['index'] for w in matched.values()):
            return  # Floating/unfloating can emit creation events for the same window.
    # Refresh only routing rules; keep the already-installed event handlers stable.
    if args.auto and not args.install:
        install(spec, space, ROOT / 'restore-layout.py', signals=False)
    restore(spec, matched, display, space, mode, args.auto)
    state_file.write_text(json.dumps(state))

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('layout', nargs='?', default='comms')
    p.add_argument('--check', action='store_true')
    p.add_argument('--auto', action='store_true', help='Arrange only open, visible apps; serialize launch events')
    p.add_argument('--window-event', action='store_true', help=argparse.SUPPRESS)
    p.add_argument('--install', action='store_true', help='Install idempotent app rules and event handlers')
    p.add_argument('--provision-portable', action='store_true', help='Remember a dedicated portable workspace')
    p.add_argument('--portable', action='store_true', help='Use stacked Comms on primary display (also for testing)')
    args = p.parse_args()
    if args.provision_portable:
        args.portable = args.auto = True
    if Path(args.layout).name != args.layout:
        p.error('Use a layout name, not a path')
    cache = Path.home() / 'Library/Caches/yabai-comms'
    cache.mkdir(parents=True, exist_ok=True, mode=0o700)
    with (cache / 'restore.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if args.auto and not args.install:
            time.sleep(0.7)
        run(args)

if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, OSError, ValueError, KeyError, StopIteration, subprocess.TimeoutExpired) as exc:
        print('Comms layout stopped:', exc, file=sys.stderr)
        sys.exit(1)
