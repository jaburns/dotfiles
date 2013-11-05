#!/bin/bash

# Get the script's running folder.
repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

files_windows=$( cat <<EOF
.minttyrc
EOF
)

files_basic=$( cat <<EOF
.bashrc
.tmux.conf
.vimrc
EOF
)

files_xmonad=$( cat <<EOF
.conkyrc
.conky.lua
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
        echo "$repo_dir/$x" '==>' "$HOME/$x"
    done
}

echo ""
echo "Linking $1 config files..."
eval "do_files \$files_$1"
echo "Done!"
echo ""

if [ "$1" == 'windows' ]; then
    echo "Linking windows _vimrc file..."
    rm -f "/cygdrive/c/Users/$(whoami)/_vimrc"
    ln "$repo_dir/.vimrc" "/cygdrive/c/Users/$(whoami)/_vimrc"
    echo "$repo_dir/.vimrc" '==>' "/cygdrive/c/Users/$(whoami)/_vimrc"
    echo "Done!"
    echo ""
fi;

