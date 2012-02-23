# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -l'
alias py2html='pygmentize -f html -O full,style=native'
alias clipboard='xsel -i -b'
#alias glog='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# git completion
source ~/.git-completion.bash

alias ls='ls -F --color=auto'

## speeed!
#if [ "$PS1" ] ; then
   #mkdir -m 0700 -p /cgroup/cpu/user/$$
   #echo $$ > /cgroup/cpu/user/$$/tasks
   #echo "1" > /cgroup/cpu/user/$$/notify_on_release
#fi


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
set -o vi
set editing-mode vi
set keymap vi
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
shopt -s globstar
shopt -s histverify

alias top=htop
alias webserver='python -m SimpleHTTPServer'

alias git-today='git diff @{yesterday}..HEAD'

alias open='xdg-open'
#alias open='gnome-open'

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

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

#alias pip='pip-python'

# SSH completion
#function _ssh_completion() {
    #perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
#}
#complete -W "$(_ssh_completion)" ssh

#complete -F get_showoff_commands
#function get_showoff_commands()
#{
    #if [ -z $2 ] ; then
        #COMPREPLY=(`showoff help -c`)
    #else
        #COMPREPLY=(`showoff help -c $2`)
    #fi
#}

source ~/.autoenv/activate.sh
