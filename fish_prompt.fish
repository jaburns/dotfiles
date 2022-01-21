function fish_prompt
    # Last status and username
    set -l pip $pipestatus
    if test $pip = 0
        set_color green
        echo -n "# $USER"
    else
        set -l promp (__fish_print_pipestatus '{' '}' '' (set_color red) (set_color red) $pip)
        set_color red
        echo -n "# $promp"
        set_color red
        echo -n " $USER"
    end

    # Kill default vi mode prompt
    function fish_mode_prompt
    end

    # Show vi mode status
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        set -l mode
        switch $fish_bind_mode
            case default
                set mode (set_color red)'[N]'
            case insert
                set mode (set_color green)'[I]'
            case replace_one
                set mode (set_color green)'[r]'
            case replace
                set mode (set_color cyan)'[R]'
            case visual
                set mode (set_color magenta)'[V]'
        end
        set mode $mode(set_color normal)
        echo -n " $mode"
    end

    # Time
    set_color magenta
    echo -n ' '(date +'%I:%M:%S%p')

    # Current dir
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0
    set_color blue
    echo -n ' '(prompt_pwd)

    # Git
    if not set -q __fish_git_prompt_showdirtystate
        set -g __fish_git_prompt_showdirtystate 1
    end
    if not set -q __fish_git_prompt_showuntrackedfiles
        set -g __fish_git_prompt_showuntrackedfiles 1
    end
    if not set -q __fish_git_prompt_showcolorhints
        set -g __fish_git_prompt_showcolorhints 1
    end
    set_color normal
    echo -n (fish_vcs_prompt)

    # Input line
    echo ''
    set_color cyan
    echo ":; "
end
