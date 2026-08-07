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
- **Zsh**: Preserves a 50k line deduplicated history (`SHARE_HISTORY`), sets up Oh My Zsh plugins, and installs the custom prompt theme (`bryankendall.zsh-theme`).
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

### Oh My Zsh Theme
```bash
mkdir -p ~/.oh-my-zsh/custom/themes
ln -s ~/dotfiles/shell/zsh/themes/bryankendall.zsh-theme ~/.oh-my-zsh/custom/themes/
```

### Git
```bash
ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/git/.githelpers ~/.githelpers
ln -s ~/dotfiles/git/.gitignore ~/.gitignore
```
