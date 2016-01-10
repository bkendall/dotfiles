# dotfiles

## vim

Add this to `~/.vimrc`

```bash
set runtimepath^=$HOME/dotfiles.git/vim
runtime vimrc
```

### command-t

Command-T needs to be compiled

```bash
cd vim/bundle/command-t/ruby/command-t
make clean
ruby extconf.rb
make
```

## shell

Add this to `~/.zshrc`

```bash
source $HOME/dotfiles.git/shell/zshrc
```

## oh-my-ssh

```bash
curl -L http://install.ohmyz.sh | sh
```

## git

Copy the contents of `./git` to `$HOME`

```bash
cp ./git/.git* $HOME
```

Need to replace some of the configuration values in `$HOME/.gitconfig`
