#!/bin/bash

REPO_DIR=$(dirname "$0")

link_file () {
  source_file="$REPO_DIR/$1"
  dest_file="${2:-$HOME/$1}"
  if [[ -e $dest_file ]]
  then
    echo "Not replacing $dest_file; back up yourself and re-run the script"
  else
    ln -sf $source_file $dest_file
  fi
}

link_file .dmrc
link_file .gitconfig
mkdir -p $HOME/.local/bin
link_file .local/bin/humanlight.sh
mkdir -p $HOME/.local/etc/rc
link_file .local/etc/rc/FixScrollPad.sh
link_file .local/etc/rc/StartNetworking.sh
link_file .p10k.zsh
link_file .themes/Windurs10
link_file .tmux.conf
link_file .vim
link_file .vimrc
link_file .vimrc_background
link_file .xbindkeysrc
link_file .Xmodmap
link_file .zshrc
mkdir -p $HOME/.config
link_file xfce4 $HOME/.config/xfce4
mkdir -p $HOME/.config/kitty
link_file kitty.conf $HOME/.config/kitty/kitty.conf
