if status is-interactive

    fish_vi_key_bindings

    # Remove greeting
    set fish_greeting

    # Auto-ls after a cd
    # function cdls
    #     functions --erase cd
    #     cd $argv
    #     ls
    #     alias cd=cdls
    # end
    # alias cd=cdls

    alias v='nvim'
    alias l='ls -lh'
    alias d='du -hd 1'
    alias cls='printf "\n\n\n\n\n\n\n\n\n\n"'
    alias dff='df -h'
    alias notes='nvim ~/syncbox/notes.txt'
    alias remap-esc='setxkbmap -option caps:escape'
    alias treee='tree -d -I  "node_modules|target|__pycache__"'
    alias setclip='xclip -selection c'
    alias getclip='xclip -selection c -o'
    alias open='xdg-open'

    alias gtree='git ls-tree -r --name-only HEAD | tree --fromfile'
    alias gg='git status'
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
    alias gl='git log --all --graph --decorate --oneline --date=relative --pretty=format:"%C(yellow)%h %C(blue)%ad %C(green)%an%C(auto)%d %C(reset)%s"'
    # alias gl_simple='git log --all --graph --decorate --oneline'
    # alias gl_noDate='git log --all --graph --decorate --oneline --pretty=format:"%C(yellow)%h %C(green)%an%C(auto)%d %C(reset)%s"'
    # alias gl_firstParent='git log --all --graph --decorate --oneline --first-parent'

    fish_add_path ~/.local/bin
    fish_add_path ~/syncbox/tools
    fish_add_path ~/dotfiles/tools
    fish_add_path ~/.cargo/bin

end
