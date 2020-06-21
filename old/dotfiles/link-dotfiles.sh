#!/bin/bash

set -e

if ! (( ${EUID:-0} || "$(id -u)" )); then
  echo "This script should not be run as root." 1>&2
  exit 1
fi

# technical debt
base_name="dotfiles/dotfiles"

source_root_path="$(pwd)/$base_name"
if (( $# < 1 )); then
  echo "Specify a valid folder in $source_root_path as the first argument to this script." 1>&2
  exit 1
fi

echo "Linking dotfiles to $HOME..."

backup_root_path="$(pwd)/$base_name.bak"
if [[ -e $backup_root_path ]]; then
  i=2
  while [[ -e $base_name-$i.bak ]]; do
    let i++
  done
  backup_root_path="$(pwd)/$base_name-$i.bak"
fi
mkdir -p "$backup_root_path"
chmod go-w "$backup_root_path"

while (( $# > 0 )); do
  folder=$1
  shift
  source_path="$source_root_path/$folder"
  echo "$source_path"
  if [[ ! -d $source_path ]]; then
    echo "$source_path is not a valid folder." 1>&2
    break
  fi
  backup_path="$backup_root_path/$folder"
  mkdir -p "$backup_path"
  chmod go-w "$backup_path"
  shopt -s dotglob nullglob
  for dotfile in "$source_path"/*; do
    dotfile="${dotfile##*/}"
    echo "$HOME/$dotfile"
    if [ -e "$HOME/$dotfile" ] || [ -L "$HOME/$dotfile" ]; then
      mv "$HOME/$dotfile" "$backup_path/$dotfile"
    fi
    ln -s "$source_path/$dotfile" "$HOME/$dotfile"
  done
  shopt -u dotglob nullglob
done

echo "Original dotfiles are located in $backup_root_path/."
