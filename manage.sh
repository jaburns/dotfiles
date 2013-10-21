#!/bin/bash

# Get the script's running folder.
repo_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Message to show if parameters are not passed correctly.
usage="Usage: manage.sh [--install|--collect] [basic|xmonad|tools|all]"

# Files to manage in "basic" mode
basic=$( cat <<EOF
.bashrc
.tmux.conf
.vimrc
EOF
)

# Files to manage in "xmonad" mode
xmonad=$( cat <<EOF
.conkyrc
.conky.lua
.xmonad/xmonad.hs
.xmonad/set-machine.sh
.xmonad/lib/CustomLog.hs
.xmonad/lib/XMonadConfig.hs
EOF
)

# Files to manage in "tools" mode
tools=$( cat <<EOF
tools/imgur-upload
EOF
)

# Determine if we're collecting up the files or installing them.
if [ "$1" == "--collect" ]; then
    printf "Collecting "
    collect=true
elif [ "$1" == "--install" ]; then
    printf "Installing "
    collect=false
else
    echo $usage
    exit
fi

# Copies the files in or out of the repo folder.
#     $1 -> true: collect files, false: install files
#     $2 -> List of files to process
#     $3 -> Parameter passed to cp
do_files () {
    for x in $2; do
        if $1; then
            echo "$HOME/$x" "==>" "$repo_dir/$x"
            mkdir -p "$(dirname "$repo_dir/$x")"
            cp "$HOME/$x" "$repo_dir/$x"
        else
            echo "$repo_dir/$x" "==>" "$HOME/$x"
            mkdir -p "$(dirname "$HOME/$x")"
            cp "$repo_dir/$x" "$HOME/$x"
        fi
    done
}

# Determine the set of configs we're processing and act accordingly.
if [ "$2" == "basic" ]; then
    echo "$2..."
    do_files $collect "$basic"
elif [ "$2" == "xmonad" ]; then
    echo "$2..."
    do_files $collect "$xmonad"
elif [ "$2" == "tools" ]; then
    echo "$2..."
    do_files $collect "$tools"
elif [ "$2" == "all" ]; then
    echo "$2..."
    $repo_dir/manage.sh "$1" basic
    $repo_dir/manage.sh "$1" xmonad
    $repo_dir/manage.sh "$1" tools
else
    echo $usage
    exit
fi

# Done!
echo 'Done!'

