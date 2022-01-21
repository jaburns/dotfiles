if status is-interactive

    fish_vi_key_bindings

    set fish_greeting

    # Auto-ls after a cd
    function cdls
        functions --erase cd
        cd $argv
        ls
        alias cd=cdls
    end
    alias cd=cdls

end
