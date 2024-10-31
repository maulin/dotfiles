#!/usr/bin/env bash

cwd=`pwd`
echo "creating symlinks"
for file in tmux.conf zshrc gitconfig; do
  echo " * $file"
  ln -sf $cwd/$file $HOME/.$file
done

ln -sf $cwd/nvim $HOME/.config/

if [ ! -d "~/.oh-my-zsh/" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
