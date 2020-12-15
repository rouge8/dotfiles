set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_char_dirtystate +
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_stateseparator

# git colors
set -g __fish_git_prompt_color_branch normal
set -g __fish_git_prompt_color_flags --bold green
# or use
# set -g __fish_git_prompt_showcolorhints 1

function fish_prompt
    set -l last_pipestatus $pipestatus
    set -l vcprompt (fish_git_prompt | string trim -c ' ()')
    echo

    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end

    if test (id -u) -eq 0
        set_color red
    else
        set_color magenta
    end
    printf '%s' $USER
    set_color grey
    printf ' at '

    set_color yellow
    echo -n (prompt_hostname)
    set_color grey
    printf ' in '

    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal

    if test $last_pipestatus != 0
        set_color grey
        printf ' exited '
        set_color red
        printf '%s' (set_color red)$last_pipestatus(set_color normal)
    end

    if test $vcprompt
        set_color grey
        printf ' on '
        set_color blue
        printf 'git:'
        set_color normal
        printf '%s' $vcprompt
    end

    if test $VIRTUAL_ENV
        set_color grey
        printf ' workon '
        printf '%s' (set_color red)(basename $VIRTUAL_ENV)(set_color normal)
    end

    echo
    printf '$ '
    set_color normal
end
