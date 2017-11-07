#.bashrc

# vi mode
set editing-mode vi
set keymap vi
set -o vi
export EDITOR="vim"

alias grep='grep --color=auto'
alias notes='vim ~/Dropbox/notes.txt'
alias music='vim ~/Dropbox/music.txt'
alias pyhttp='python -m SimpleHTTPServer'
alias ywd='printf "%q" "$(pwd)" | pbcopy'
alias dskill='find . -name .DS_Store > /tmp/dskill && wc -l /tmp/dskill | sed "s:/.*$:.DS_Store files removed:" && while read line; do rm "$line"; done < /tmp/dskill && rm /tmp/dskill'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias lss='du -hd 1'
alias ports='sudo netstat -tulpn'
alias unity='/Applications/Unity/Unity.app/Contents/MacOS/Unity'
alias mkv2mp4='for x in *.mkv; do ffmpeg -i "$x" -vcodec copy -acodec libfaac "$x.mp4"; done'
alias agls='ag . -l --nocolor -g ""'
alias treed='tree -d -I node_modules'
alias parent='ps -o comm= $PPID'
alias hosts='sudo vi /etc/hosts'

# Windows-specific stuff
if [[ -d /mnt/c/Windows ]]; then
    alias open='/mnt/c/Windows/explorer.exe'
    alias code='/mnt/c/Program\ Files/Microsoft\ VS\ Code/Code.exe &'
    alias ps1='powershell.exe'

    # Needed on WSL to use clipboard
    export DISPLAY=localhost:0.0
else
    alias code='/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron &'
fi

export PATH=$PATH:$HOME/tools
export PATH=$PATH:$HOME/dotfiles/tools
export PATH=$PATH:$HOME/.cabal/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/Applications/Adobe\ Flash\ Builder\ 4.7/eclipse/plugins/com.adobe.flash.compiler_4.7.0.349722/AIRSDK/bin

export RUST_SRC_PATH=$HOME/sources/rust/src

command -v vim >/dev/null 2>&1 && alias vi='vim'


# ----- Node version manager --------------------------------------------------

export NVM_DIR="/Users/jaburns/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# ----- Simple commands -------------------------------------------------------

docker_kill() {
    docker ps | awk '{print $1}' | grep -v CONTAINER | xargs docker stop
    docker ps -a | awk '{print $1}' | grep -v CONTAINER | xargs docker rm
}

docker_clean() {
    docker_kill
    docker images | awk '{print $3}' | grep -v IMAGE | xargs docker rmi --force
}

# Find a file with name containing some text
finn() {
    find . -iname "*$1*"
}

# Print the default dimensions of a SWF, local or remote
swfsize() {
    php -r "print_r(getimagesize('$1'));"
}

# Wait for a process to close then run a command
after() {
    while :; do
        echo "\nWaiting for..."
        if ! ps aux | grep "$1" | grep -v grep; then
            eval "$2"
            break
        fi
        sleep 2
    done
}

# Rename some files with sed regex
ren() {
    [[ -z $1 ]] && echo "Example: ren '*.txt' 's/-suffix/-newsuff/'" && return
    [[ -z $2 ]] && find . -iname "$1" && return
    find . -iname "$1" | while read x; do
        mv "$x" "$(echo "$x" | sed "$2")";
    done
}

# Find and replace in files that match an ag search
agsed() {
    if [[ -z $1 ]]; then
        echo "Example: agsed 'import xyz' 's/xyz/abc/'"
        echo 'Supply first param only to run ag search without replace'
        return
    fi
    [[ -z $2 ]] && ag "$1"
    ag "$1" | cut -d: -f1 | xargs sed -i '' -e "$2"
}

# ----- set default output for ls; add auto ls after cd -----------------------

if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi
alias ll='ls --color=never'

cdls() {
    cd "$1"
    local cderr="$?"
    if [[ "$cderr" -eq '0' ]]; then
        [[ "$1" = '-' ]] || pwd
        shift
        ls "$@"
    fi
    return "$cderr"
}

alias cd='cdls'

# ----- easy way to navigate to a dir parent ----------------------------------

function cdup {
    local newdir="${PWD/\/$1\/*/}/$1"
    if [[ -d "$newdir" ]]
    then
        cd "$newdir"
    else
        echo "\"$newdir\" does not exist"
    fi
}

function _cdup_complete {
    local word=${COMP_WORDS[COMP_CWORD]}
    local list=$(pwd | cut -c 2- | sed -e 's#/[^/]*$##g' -e 's/\([ ()]\)/\\\\\1/g')
    IFS=/
    list=$(compgen -W "$list" -- "$word")
    IFS=$'\n'
    COMPREPLY=($list)
    return 0
}

complete -F _cdup_complete cdup

# ----- ack helpers -----------------------------------------------------------

ack_formatted() {
    local lang=$1
    shift
    printf "\n\n\n    $@\n\n"
    ack $lang "$@"
    printf "\n\n\n\n"
}

alias cck='ack_formatted --csharp'
alias aak='ack_formatted --actionscript'

# ----- git helpers -----------------------------------------------------------

# git config --global credential.helper "cache --timeout=3600"
# git config --global color.ui auto

if ! which gxargs >/dev/null 2>/dev/null; then
    alias gxargs=xargs
fi

gg() {
    local cmd=
    if [[ "$#" -lt 1 ]]; then
        git status
    elif [[ "$#" -lt 2 ]]; then
        git ls-files -m -o --exclude-standard | grep "$1"
        read cmd
        [[ ! -z "$cmd" ]] && gg "$1" $cmd
    else
        local gurp="$1"
        shift
        if [[ "$1" = '!' ]]; then
            shift
            git ls-files -m -o --exclude-standard | grep "$gurp" | gxargs -d"\n" "$@"
        else
            git ls-files -m -o --exclude-standard | grep "$gurp" | gxargs -d"\n" git "$@"
        fi
        if [[ "$@" != 'diff' ]]; then
            git status
        fi
    fi
}

gmon() {
    if [[ ! -z "$1" ]]; then
        local nap="$1"
    else
        local nap=5
    fi

    while :; do
        clear
        git ls-files -m -o --exclude-standard | grep '\.cs$' | gxargs -d"\n" git --no-pager diff
        sleep "$nap"
    done
}

gd() {
    if [[ -z "$1" ]]; then
        git diff
    else
        git diff "$1"^ "$1"
    fi
}

git-nuke() {
    ls -1a | while read line; do
        if [[ "$line" != "." && "$line" != ".." && "$line" != ".git" ]]; then
            rm -rf "$line"
        fi
    done
    git reset --hard
}

alias gc='git commit'
alias ga='git add'
alias gp='git push'
alias gu='git pull --rebase'
alias gsu='git stash && git pull --rebase && git stash pop'
alias gf='git fetch --all'
alias gr='git rebase'
alias gm='git merge'
alias gco='git checkout'
alias gb='git branch'
alias gcp='git cherry-pick'
alias glf='git log --all --graph --decorate --oneline --first-parent'
alias gl='git log --all --graph --decorate --oneline'
alias gmt='git mergetool'

_gb_complete() {
    local word=${COMP_WORDS[COMP_CWORD]}
    local list=$(git branch --all | sed 's/^. //;s/ .*$//')
    list=$(compgen -W "$list" -- "$word")
    COMPREPLY=($list)
    return 0
}

complete -F _gb_complete gb
complete -F _gb_complete gco
complete -F _gb_complete gm
complete -F _gb_complete gr

# ----- Autocomplete make command, look inside makefile -----------------------

_makefile_complete() {
    local name=makefile
    [[ ! -e "$name" ]] && local name=Makefile
    [[ ! -e "$name" ]] && return 0

    local word=${COMP_WORDS[COMP_CWORD]}
    local list=$(grep "^[^ $(printf '\t')]*:" "$name" | cut -f1 -d:)
    list=$(compgen -W "$list" -- "$word")
    COMPREPLY=($list)
    return 0
}

complete -F _makefile_complete make

# ----- SVN helpers -----------------------------------------------------------

# Grep SVN status for a pattern and execute an svn command on the selection.
sg() {
    if [[ "$#" -lt 1 ]]; then
        svn st
    elif [[ "$#" -lt 2 ]]; then
        svn st | grep "$1" | awk '{print $2}'
    else
        svn st | grep "$1" | sed 's/^. *//g;s/\(.*\)/"\1"/' | xargs svn "$2"
    fi;
}

# Remove all deleted files, and add all new files.
sa() {
    test `sg '!' | wc -l` -gt 0 && sg '!' rm
    test `sg '?' | wc -l` -gt 0 && sg '?' add
}

# Show the log from HEAD back n revisions
svl() {
    rev=$(svn info | grep 'Revision' | cut -d\  -f2)
    svn log -r "$(expr $rev - $1):HEAD"
}

# Quick alias for editing the ignore list in svn
alias si='svn propedit svn:ignore .'

# ----- node.js breakpoint debugger setup -------------------------------------

ndb() {
    local params="$@"
    [[ -z "$params" ]] && local params=.
    tmux split-window -v "node --debug-brk $params"
    sleep 0.2
    tmux split-window -h 'node-vim-inspector'
    tmux swap-pane -U
    tmux select-pane -U
    vim -nb
}

# ----- Prompt config ---------------------------------------------------------

ps1_error() {
    if [[ "$1" -eq 0 ]]; then
        echo -n '\[\033[0;32m\]'
    else
        echo -n '\[\033[0;31m\]'
        echo -n "$1 "
    fi;
}
ps1_git_branch() {
    local br="$(git branch 2> /dev/null)"
    if [[ ! -z "$br" ]]; then
        echo -n '\[\033[0;35m\] '
        echo -n "$br" | sed '/^[^*]/d;s/* \(.*\)/ \1/' | xargs echo -n
    fi
}
ps1_render() {
    # Error number and username
    echo -n "$(ps1_error $1)"
    echo -n '\u '

    # Time
    echo -n '\[\033[0;35m\]'
    echo -n "$(date +'%I:%M:%S%p') "

    # Path
    echo -n '\[\033[0;34m\]\w'

    # Git branch and newline/prompt
    echo    "$(ps1_git_branch)"
    echo -n '\[\033[0;36m\]$) \[\033[0m\]'
}
export PROMPT_COMMAND='PS1="$(ps1_render $?)"'

# Fix ugly dir colors on WSL
if [[ -d /mnt/c/Windows ]]; then
    eval "$(dircolors ~/.dircolors)"
fi

