#!/bin/bash

# Get the script's running folder.
repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

files_basic=$( cat <<EOF
.bashrc
.tmux.conf
.vimrc
EOF
)

files_xmonad=$( cat <<EOF
.conkyrc
.conky.lua
.xmonad/xmonad.hs
.xmonad/set-machine.sh
.xmonad/lib/CustomLog.hs
.xmonad/lib/XMonadConfig.hs
EOF
)

do_files () {
    for x in $*; do
        [ -a "$HOME/$x" ] && rm "$HOME/$x"
        mkdir -p "$(dirname "$HOME/$x")"
        ln "$repo_dir/$x" "$HOME/$x"
        echo "$HOME/$x" "==>" "$repo_dir/$x"
    done
}

echo "Linking $1 config files..."
eval "do_files \$files_$1"
echo "Done!"
