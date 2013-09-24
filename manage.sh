#!/bin/bash

# Get the script's running folder.
repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define the files we're keeping track of.
file_list=$( cat <<EOF
.bashrc
.conkyrc
.conky.lua
.vimrc
.xmonad/xmonad.hs
tools/imgur-upload
EOF
)

# Determine if we're collecting up the files or installing them.
if [ "$1" == "--collect" ]; then
    echo "Collecting dotfiles..."
    collect=true
elif [ "$1" == "--install" ]; then
    echo "Installing dotfiles..."
    collect=false
else
    echo "Usage: manage.sh [--install|--collect]"
    exit
fi

# Copy the files in or out of the repo folder.
for x in $file_list; do
    if $collect; then
        cp "$HOME/$x" "$repo_dir/$x"
    else
        cp "$repo_dir/$x" "$HOME/$x"
    fi
done

echo 'Done!'

