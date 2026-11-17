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

All six apps/windows must be open and unminimized. The iTerm windows must
be named `PR Reviewer` and `Slack Proxy`. Extra tiled windows must be moved
or floated before restoring; floating windows such as Slack huddles are
left alone. No apps are launched or restarted automatically.

`comms.json` stores the monitor and workspace UUIDs, window matches, split
tree, and geometry. Adjust it for a different monitor or set of apps.
If the saved workspace no longer exists, the command uses the monitor's
sole ordinary workspace; it refuses an ambiguous destination.

If an app stops responding to tiling after being rebuilt or renamed,
Yabai may need its window tracking refreshed. A restore verifies the final
window frames and reports mismatches; it does not restart Yabai automatically.
If a restore fails midway, windows may need rearranging before retrying.
