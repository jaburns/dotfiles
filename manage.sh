#!/bin/bash

# Get the script's running folder.
repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define the dotfiles we're keeping track of in this format:
#   Name in repo : Path and name relative to home
file_list=$( cat <<EOF
.bashrc:.bashrc
.conkyrc:.conkyrc
.vimrc:.vimrc
xmonad.hs:.xmonad/xmonad.hs
EOF
)

# Determine if we're collecting up the dotfiles or installing them.
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

# Copy the dotfiles in or out of the repo folder.
for x in $file_list; do
    A="$repo_dir/$( echo $x | cut -d: -f1 )"
    B="$HOME/$( echo $x | cut -d: -f2)"
    if $collect; then
        cp "$B" "$A"
    else
        cp "$A" "$B"
    fi
done

echo 'Done!'

