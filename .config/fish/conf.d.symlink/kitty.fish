if test $TERM = 'xterm-kitty'
    alias ssh 'kitty +kitten ssh'
end

alias icat 'kitty +kitten icat'

function kg --wraps rg
    kitty +kitten hyperlinked_grep $argv
end
