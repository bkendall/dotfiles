# dotfiles

Personal dotfiles for standardizing shell (Zsh + Oh My Zsh), Git, and Vim environments across macOS and Linux.

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bkendall/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installer**:
   ```bash
   ./install.sh
   ```

3. **Verify configuration with Doctor mode**:
   ```bash
   ./install.sh --doctor
   ```

---

## Features & Configuration

- **`install.sh`**: One-command installer that symlinks configs into `$HOME` and provides a `--doctor` mode to diagnose issues.
- **Zsh & Prompt**: Automatically uses [Starship](https://starship.rs/) if installed, or falls back to native Zsh `vcs_info` for fast, zero-dependency Git status indicators and job counters. Includes 50k deduplicated persistent history (`SHARE_HISTORY`).
- **Vim**: Configured with `vim-plug` and `vim-lsp` / `vim-lsp-settings` for zero-config Language Server Protocol (auto-format on save, diagnostics, definition lookup) and Solarized dark theme.
- **Git**: Configured with Gary Bernhardt's `pretty_git_log` tree helper, modern defaults (`init.defaultBranch = main`, `pull.rebase = true`, `branch.sort = -committerdate`), and custom diff tools.

---

## Manual Setup Reference

If you prefer manual setup over `./install.sh`:

### Vim
Add to `~/.vimrc`:
```vim
set runtimepath^=$HOME/dotfiles/vim | runtime vimrc
```

### Zsh
Add to `~/.zshrc`:
```zsh
source "$HOME/dotfiles/shell/zshrc"
```

### Git
```bash
ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/git/.githelpers ~/.githelpers
ln -s ~/dotfiles/git/.gitignore ~/.gitignore
```
