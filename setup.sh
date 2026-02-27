#!/usr/bin/env bash

REPO_DIR=$(dirname "$0")
REPO_DIR=$(realpath $REPO_DIR)

make_link () {
  link_type="$1"
  if [[ $link_type != "file" && $link_type != "directory" ]]
  then
    return
  fi

  source_file="$REPO_DIR/$2"
  dest_file="${3:-$HOME/$2}"

  # Check if link has already been created
  if [[ -h $dest_file ]]
  then
    echo "\"$dest_file\" is already linked, not linking again."
  else
    if [[ ($link_type == "file" && -f $dest_file) || ($link_type == "directory" && -d $dest_file) ]]
    then
      dest_file_backup="$dest_file.backup"
      echo "Backing up \"$dest_file\"..."
      mv "$dest_file" "$dest_file.backup"
    fi
    echo "Linking \"$dest_file\"..."
    mkdir -p $(dirname $dest_file)
    ln -sf $source_file $dest_file
  fi
}

make_link file .gitconfig
# make_link file .local/bin/humanlight.sh
# make_link file .local/bin/runaswine
make_link file .local/bin/nvim
# make_link file .local/etc/rc/FixScrollPad.sh
# make_link file .local/etc/rc/StartNetworking.sh
# make_link file .zshrc
# mkdir -p "$HOME/.zsh_config"
make_link file .zshrc.p10k
# make_link file .zshrc.extra-msys2 .zshrc.extra
# make_link file .zshrc.extra-archlinux .zshrc.extra
# make_link directory powerlevel10k
# make_link directory .themes/Windurs10
# make_link file .tmux.conf
make_link file .vimrc
make_link file init.lua "$HOME/.config/nvim/init.lua"
# make_link file coc-settings.json "$HOME/.config/nvim/coc-settings.json"
# make_link directory .vim
# make_link file .xbindkeysrc
# make_link file .Xmodmap
# make_link file .dmrc
# make_link directory xfce4 "$HOME/.config/xfce4"
make_link directory kitty "$HOME/.config/kitty"
# make_link directory nix "$HOME/.config/nix"
# make_link directory snippets "$HOME/.config/nvim/snippets"
