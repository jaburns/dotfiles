#.bashrc
# cd "$(dirname "${BASH_SOURCE[0]}")" # For reference

set editing-mode vi
set keymap vi
set -o vi
export EDITOR="nvim"

alias v='nvim'
alias l='ls -lh'
alias d='du -hd 1'
alias cls='printf "\n\n\n\n\n\n\n\n\n\n"'
alias dff='df -h'
alias notes='nvim ~/syncbox/notes.txt'
alias grep='grep --color=auto'
alias remap-esc='setxkbmap -option caps:escape'
alias treee='tree -d -I  "node_modules|target|__pycache__"'
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"

if [[ "$OSTYPE" == *linux-gnu* ]]; then
    alias open='xdg-open'
fi
# if [[ "$OSTYPE" == "msys" ]]; then
#     export PATH=$PATH:/c/nvim/bin
#     alias vim='nvim'
#     alias vi='nvim'
# fi

export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/syncbox/tools
export PATH=$PATH:$HOME/dotfiles/tools
export PATH=$PATH:$HOME/.cargo/bin

export FrameworkPathOverride=/etc/mono/4.5

# ----- Simple commands -------------------------------------------------------

timer() {
    (
        sleep "$1"
        notify-send -i face-smile TIMER "$2"
    ) &
}

# Find a file with name containing some text
finn() {
    find . -iname "*$1*"
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

# Completely reset the state of a git repo and all its submodules
gitfuck() {
    git clean -xfd
    git submodule foreach --recursive git clean -xfd
    git reset --hard
    git submodule foreach --recursive git reset --hard
    git submodule update --init --recursive
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
    if [[ -z $2 ]]; then
        rg "$1"
    else
        rg "$1" | cut -d: -f1 | xargs sed -i -e "$2"
    fi
}

# ----- set default output for ls; add auto ls after cd -----------------------

if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

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

# ----- git helpers -----------------------------------------------------------

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

gd() {
    if [[ -z "$1" ]]; then
        git diff
    else
        git diff "$1"^ "$1"
    fi
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
alias gl='git log --all --graph --decorate --oneline --pretty=format:"%C(yellow)%h %C(green)%an%C(auto)%d %C(reset)%s"'
alias glf='git log --all --graph --decorate --oneline --first-parent'
alias gld='git log --all --graph --decorate --oneline --date=relative --pretty=format:"%C(yellow)%h %C(blue)%ad %C(green)%an%C(auto)%d %C(reset)%s"'
alias gll='git log --all --graph --decorate --oneline'

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

# ----- Prompt config ---------------------------------------------------------

ps1_error() {
    if [[ "$1" -eq 0 ]]; then
        echo -n '\[\033[0;32m\]# '
    else
        echo -n '\[\033[0;31m\]# '
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

    # Git branch and newline/prompt (too slow to be worth it on msys)
    echo    "$([[ "$OSTYPE" == "msys" ]] || ps1_git_branch)"
    echo -n '\[\033[0;36m\]:; \[\033[0m\]'
}

# Disable ctrl-s freezing terminal output
stty -ixon

# history -a..-r appends unwritten history to .bash_history immediately
# and reloads to avoid losing history with multiple shells open
export PROMPT_COMMAND='PS1="$(ps1_render $?)";history -a;history -r'

# External configs
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f '/usr/share/nvm/init-nvm.sh' ]] && source '/usr/share/nvm/init-nvm.sh'
[[ -f '/usr/share/autojump/autojump.bash' ]] && source '/usr/share/autojump/autojump.bash'
