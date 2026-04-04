# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS dotfiles managed with [RCM](https://github.com/thoughtbot/rcm). Files at the repo root are symlinked to `$HOME` by `rcup` (e.g., `zshrc` → `~/.zshrc`). Subdirectories like `ssh/` are symlinked as `~/.ssh/`.

## Setup and Usage

```bash
# Fresh install: clone, bootstrap Homebrew packages, and symlink dotfiles
./install.sh

# Re-symlink after adding/removing files (excludes are in install.sh)
rcup -v -x README.md -x install.sh -x com.googlecode.iterm2.plist -x update.sh

# Apply macOS system defaults (requires sudo, restarts affected apps)
.osx/defaults.sh
```

## Key Details

- **Secrets**: `~/.secrets.zsh` is sourced by `zshrc` but gitignored — never commit secrets.
- **RCM exclusions**: `install.sh` excludes `README.md`, `install.sh`, `com.googlecode.iterm2.plist`, and `update.sh` from symlinking. If adding new non-dotfile scripts, add them to the exclusion list.
- **iTerm2 plist**: `com.googlecode.iterm2.plist` is tracked but not symlinked by RCM — it must be loaded manually in iTerm2 preferences.
- **Window management**: `yabairc` (tiling WM config) and `skhdrc` (hotkey bindings) work together via yabai + skhd.
- **Version managers**: `nodenv` is active in `zshrc`; `pyenv` and `rbenv` are installed but commented out.
- **Shell**: zsh with Powerlevel10k theme (installed via Homebrew).
