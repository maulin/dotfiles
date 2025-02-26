#!/usr/bin/env bash

cwd=`pwd`
echo "Copying files"
for file in tmux.conf zshrc gitconfig; do
  target_file="$HOME/.$file"

  # Check if file exists or is a symlink
  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    echo " * Moving existing $target_file to $target_file.old"
    mv "$target_file" "$target_file.old"
  fi

  echo "Creating symlink for $file"
  ln -s "$cwd/$file" "$target_file"
done

ln -sf $cwd/nvim $HOME/.config/

if [ ! -d "$HOME/.oh-my-zsh/" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
