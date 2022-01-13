#!/usr/bin/env bash

if [ SPIN ]; then
  sudo apt purge neovim
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt update && sudo apt-get install -y neovim
fi

if [ ! -e ~/.vim/autoload/plug.vim ]; then
  echo "installing plug for vim packages"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

cwd=`pwd`
echo "creating symlinks"
for file in vimrc tmux.conf zshrc test_commands.sh gitignore_global; do
  echo " * $file"
  ln -sf $cwd/$file $HOME/.$file
done

mkdir -p $HOME/.config/nvim
ln -sf $cwd/init.vim $HOME/.config/nvim/init.vim
