#!/usr/bin/env bash

if [ ! -e ~/.vim/autoload/plug.vim ]; then
  echo "installing plug for vim packages"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

cwd=`pwd`
echo "creating symlinks"
for file in vimrc tmux.conf zshrc test_commands.sh gitignore_global gitconfig; do
  echo " * $file"
  ln -sf $cwd/$file $HOME/.$file
done

mkdir -p $HOME/.config/nvim
ln -sf $cwd/init.vim $HOME/.config/nvim/init.vim

if [ ! -d "~/.oh-my-zsh/" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
