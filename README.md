# dotfiles

## vim

Add this to `~/.vimrc`

```bash
set runtimepath^=$HOME/dotfiles/vim
runtime vimrc
```

## shell

Add this to `~/.zshrc`

```bash
source $HOME/dotfiles/shell/zshrc
```

## oh-my-zsh

```bash
apt-get install zsh
# chsh -s /bin/zsh [username]
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## zsh theme

```bash
cp ./shell/zsh/themes/bryankendall.zsh-theme ~/.oh-my-zsh/themes/
```

## git

Copy the contents of `./git` to `$HOME`

```bash
cp ./git/.git* $HOME
```

Need to replace some of the configuration values in `$HOME/.gitconfig`
