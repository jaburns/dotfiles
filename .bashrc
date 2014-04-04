#.bashrc

# vi mode
set editing-mode vi
set keymap vi
set -o vi
export EDITOR="vim"

# Basic command default parameters
alias l='ls -1aG'
alias grep='grep --color=auto'

alias cck='echo && echo && echo && echo && ack --csharp'
alias aak='echo && echo && echo && echo && ack --actionscript'

alias notes='vim ~/Dropbox/notes.txt'
alias pyhttp='python -m SimpleHTTPServer'

export PATH=$PATH:$HOME/tools
export PATH=$PATH:$HOME/dotfiles/tools
export PATH=$PATH:$HOME/.cabal/bin

# ----- git helpers -----------------------------------------------------------

# git config --global credential.helper "cache --timeout=3600"
# git config --global color.ui auto

gg () {
    if [ "$#" -lt 1 ]; then
        git status
    elif [ "$#" -lt 2 ]; then
        git ls-files -m -o | grep "$1"
    else
        git ls-files -m -o | grep "$1" | xargs git "$2"
    fi;
}

alias gc='git commit'
alias gd='git diff'
alias ga='git add'
alias gp='git push'
alias gu='git pull'

# ----- SVN helpers -----------------------------------------------------------

# Grep SVN status for a pattern and execute an svn command on the selection.
sg () {
    if [ "$#" -lt 1 ]; then
        svn st
    elif [ "$#" -lt 2 ]; then
        svn st | grep "$1" | awk '{print $2}'
    else
        svn st | grep "$1" | sed 's/^. *//g;s/\(.*\)/"\1"/' | xargs svn "$2"
    fi;
}

# Remove all deleted files, and add all new files.
sa () {
    test `sg '!' | wc -l` -gt 0 && sg '!' rm
    test `sg '?' | wc -l` -gt 0 && sg '?' add
}

# Show the log from HEAD back n revisions
sl () {
    rev=$(svn info | grep 'Revision' | cut -d\  -f2)
    svn log -r "$(expr $rev - $1):HEAD"
}

# Quick alias for editing the ignore list in svn
alias si='svn propedit svn:ignore .'

# ----- Prompt config ---------------------------------------------------------

ps1_color_error () {
    if [ "$1" -eq 0 ]; then
        printf '32'
    else
        printf '31'
    fi;
    exit $1
}
ps1_value_error () {
    if [ "$1" -gt 0 ]; then
        printf " $1 "
    fi;
}
export PS1='\[\033[0;$(ps1_color_error $?)m\]$(ps1_value_error $?)\u\[\033[0;34m\] \W) \[\033[0m\]'
