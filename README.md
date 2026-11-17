# dotfiles

## Usage

To clone and install:
```bash
git clone https://github.com/JELGT2011/.dotfiles.git $HOME/.dotfiles && cd $_
./install.sh
```

To update, just run the `update.sh` script.


## Attributions

Dependencies:
* [YADR](https://github.com/skwp/dotfiles)
* [RCM](https://github.com/thoughtbot/rcm)
* [powerline patched fonts](https://github.com/powerline/fonts)

## Saved Yabai layout

Control–Shift–R restores the `comms` layout on the saved second monitor:
Linear and Slack across the top; PR Reviewer, Slack Proxy, native Jarvis,
and Kalshi AI across the bottom. The layout keeps BSP tiling with 10-pixel
padding and gaps.

The tracked files in `config/yabai/layouts/` are the source of truth. RCM
installs them as individual symlinks under `~/.config/yabai/layouts/`, just
like `yabairc` and `skhdrc`. The standard `./install.sh` includes them.
To restore only these links on an existing installation:

```sh
rcup -v config/yabai/layouts/comms.json config/yabai/layouts/restore-comms config/yabai/layouts/restore-layout.py
```

To run manually:

```sh
~/.config/yabai/layouts/restore-comms --check  # validate without moving windows
~/.config/yabai/layouts/restore-comms          # restore the saved layout
```

Launch defaults are installed by `yabairc` using `restore-layout.py --auto --install`.
App rules send Linear, Slack, PR Reviewer, Slack Proxy, Jarvis, and Kalshi AI
to the dedicated workspace; event handlers restore their order after launch,
unhide, minimize/restore, or monitor changes. Only visible, unminimized windows
participate in automatic placement. With fewer apps open, the remaining BSP
branches expand into available space. The manual shortcut still requires all
six windows. Slack huddles and auxiliary dialogs remain floating.

When the saved second monitor is connected, the target is **Comms**, using the
original BSP slots. When it is absent, the target is **Comms-portable**, using
stack layout so each app gets the available screen area. Switch apps normally
to bring a stacked window forward. Reconnecting returns the apps to Comms.
The portable workspace can also be selected manually:

```sh
~/.config/yabai/layouts/restore-comms --auto --portable
```

`comms.json` stores the monitor/workspace UUIDs, window matches, and split tree.
Workspace labels are re-established from those UUIDs after Yabai restarts;
routing rules are refreshed when the monitor topology changes. No hardcoded
workspace numbers are used. Restore calls serialize, ignore duplicate launch
events for the same windows, and return focus to the previously focused window.
Logs are in `/tmp/yabai-comms-$(id -u).log`.

SIP can stay enabled. Desktops are provisioned once through Mission Control;
the scripts only label them and move app windows between them. On a new Mac
or if a dedicated Desktop is deleted, create an empty Desktop on the target
screen. For the portable Desktop, remember it with:

```sh
~/.config/yabai/layouts/restore-comms --provision-portable
```

Extra unrelated tiled windows on the destination must be moved or floated
before restoring. No apps or services are launched, quit, or restarted by these
scripts. Install/uninstall the runtime rules and signals by reloading Yabai;
remove the Comms launch-defaults line from `yabairc` to disable them on startup.

If an app stops responding to tiling after being rebuilt or renamed,
Yabai may need its window tracking refreshed. A restore verifies the final
window frames and reports mismatches; it does not restart Yabai automatically.
If a restore fails midway, windows may need rearranging before retrying.
