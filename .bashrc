# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -l'
alias py2html='pygmentize -f html -O full,style=native'
alias clipboard='xsel -i -b'
#alias glog='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias ddprogress='killall -USR1 dd'
alias vundle-update='vim -u ~/.bundles.vim +BundleInstall +q'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [[ `uname` == 'Linux' ]]; then
    alias ls='ls --color=auto -F'
elif [[ `uname` == 'Darwin' ]]; then
    alias ls='ls -G -F'
fi


## functions from http://code.toofishes.net/cgit/dan/configfiles.git/tree/bashrc
# sanitize - set file/directory owner and permissions to normal values (644/755)
# Usage: sanitize <file>
sanitize() {
	chmod -R u=rwX,go=rX "$@"
	chown -R ${USER}:${USER} "$@"
}

# psfind - shortcut for grepping a process name
# Usage: psfind <process name>
psfind() {
	ps -ef | egrep "PID|$@"
}

# notes! from http://jasonwryan.com/post/1203000683/awk-notes
n() {
        $EDITOR ~/.notes/"$*".txt
}
nls() { tree -CR --noreport ~/.notes | awk '{ if (NF==1) print $1; else if (NF==2) print $2; else if (NF==3) print " "$3 }' ; }

case "$TERM" in
    xterm*) TERM=xterm-256color
esac

# bash vi editing mode
# from http://www.catonmat.net/blog/bash-vi-editing-mode-cheat-sheet/
#set -o vi
#set editing-mode vi
#set keymap vi
# ^p check for partial match in history
bind -m vi-insert "\C-p":dynamic-complete-history

# ^n cycle through the list of partial matches
bind -m vi-insert "\C-n":menu-complete

export HISTFILESIZE=500000
export HISTSIZE=100000
export HISTIGNORE="&:[ ]*:exit"
shopt -s histappend
shopt -s cmdhist
export HISTTIMEFORMAT='%F %T '
# use ** to search any depth
if [[ `uname` != Darwin ]]; then
    shopt -s globstar
fi
shopt -s histverify

alias top=htop
alias webserver='python -m SimpleHTTPServer'

alias git-today='git diff @{yesterday}..HEAD'

if [ `type -P xdg-open` ]; then
    alias open='xdg-open'
fi

# uploads gifs to f.rouge8.com
function upgif {
    if [ $# == 2 ]
    then
        GIF=$2
    else
        GIF=$1
    fi
    scp $GIF rouge8-files:/home/public/gifs/
    echo "http://f.rouge8.com/gifs/$GIF"
    boom gifs ${GIF%.gif} "http://f.rouge8.com/gifs/$GIF"
}

# list my damn gifs
function lsgifs {
for i in $(ssh rouge8-files ls -1 /home/public/gifs/ | xargs -L1);
    do echo "http://f.rouge8.com/gifs/$i";
done;
}

# get a gif!
function getgif {
    scp "rouge8-files:/home/public/gifs/$1" .
}

# mustachio
function mustachio {
    if [ $# -ne 2 ]; then
        echo "USAGE: mustachio imgurl name"
    else
        if [[ $1 == http* ]]
        then
            curl -o "/tmp/$2.jpg" "http://mustachio.heroku.com/?src=$1"
            scp "/tmp/$2.jpg" rouge8-files:/home/public/mustaches/
            boom mustaches $2 "http://f.rouge8.com/mustaches/$2.jpg"
        else
            scp $1 "rouge8-files:/home/public/mustaches/$2.jpg"
            curl -o "/tmp/$2.jpg" "http://mustachio.heroku.com/?src=http://f.rouge8.com/mustaches/$2.jpg"
            boom mustaches $2 "http://f.rouge8.com/mustaches/$2.jpg"
        fi
    fi
}

function pdp8run {
    pal -r $1.pal
    coremake $1.core < $1.rim
    pdp8e $1.core
}

function gimmedatjson {
    curl "$*" | python -m json.tool | pygmentize -l javascript
}

alias Terminal="/usr/bin/ssh-agent /usr/bin/Terminal"
alias httpcode="/usr/bin/hc"

if [[ `uname` != 'Darwin' ]]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

if [ -f ~/.autoenv/activate.sh ]; then
    source ~/.autoenv/activate.sh
fi

# convert cprofile output to something useful
function cprof2png {
    gprof2dot -f pstats $1 | dot -Tpng -o $1.png
}
function cprof2dot {
    gprof2dot -f pstats $1 > $1.dot
}

# human readable du -sh
function duf {
du -sk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done

}

# GREP_OPTIONS=
# if grep --help | grep -- --exclude-dir &>/dev/null; then
for PATTERN in .cvs .git .hg .svn; do
    GREP_OPTIONS="$GREP_OPTIONS --exclude-dir=$PATTERN"
done
# fi
export GREP_OPTIONS

# Bash completions
if [[ -d $HOME/.bash_completion.d ]]; then
    for f in $HOME/.bash_completion.d/*; do
        source $f
    done
fi
