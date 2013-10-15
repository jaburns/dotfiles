#.bashrc

# vi mode
set editing-mode vi
set keymap vi
set -o vi
export EDITOR="vim"

# Command aliases
alias l='ls -1aG'
alias grep='grep --color=auto'

# Add personal toolbox to path
export PATH=$PATH:/home/jaburns/tools

# Colored prompt with error display
ps1_color_error () {
    if [ "$1" -eq 0 ]; then
        tput setaf 2
    else
        tput setaf 1
        echo " $1 "
    fi;
}
export PS1="\$(ps1_color_error \$?)\u\$(tput setaf 4) \W)\$(tput sgr0) "
