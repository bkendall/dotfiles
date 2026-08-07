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

## What `install.sh` Configures

- **Git Submodules**: Initializes and updates submodules (e.g. `syntastic`).
- **Vim**: Configures `~/.vimrc` to source `dotfiles/vim` and creates `~/.vim/undodir` and `~/.vim/backup`.
- **Zsh**: Configures `~/.zshrc` to source `dotfiles/shell/zshrc` and links `bryankendall.zsh-theme` to `~/.oh-my-zsh/custom/themes/`.
- **Git**: Symlinks `.gitconfig`, `.githelpers`, `.gitignore`, and `.gitk` into `$HOME/`.

---

## Manual Setup Reference

If you prefer to set up manually without `install.sh`:

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
