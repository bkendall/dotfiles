dotfiles
========

vim
---

Add this to `~/.vimrc`

    set runtimepath^=$HOME/dotfiles.git/vim
    runtime vimrc

shell
-----

Add this to `~/.zshrc`

    source $HOME/dotfiles.git/shell/zshrc

oh-my-ssh
---
  curl -L http://install.ohmyz.sh | sh
