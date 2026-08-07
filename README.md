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

## oh-my-ssh

```bash
apt-get install zsh
# chsh -s /bin/zsh [username]
curl -L http://install.ohmyz.sh | sh
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
