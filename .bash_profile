# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.gem/ruby/1.8/bin:$HOME/Library/Python/2.7/bin
export GOROOT=$HOME/local/go
export PATH=$PATH:$GOROOT/bin
export EDITOR=vim


export PATH
unset USERNAME
if [ "$SSH_CONNECTION" != "" ]; then
    export TERM=xterm
fi

# My prompt!
# stolen from <https://github.com/mitsuhiko/dotfiles/blob/master/bash/bashrc>
MITSUHIKOS_DEFAULT_COLOR="[00m"
MITSUHIKOS_GRAY_COLOR="[37m"
MITSUHIKOS_PINK_COLOR="[35m"
MITSUHIKOS_GREEN_COLOR="[32m"
MITSUHIKOS_ORANGE_COLOR="[33m"
MITSUHIKOS_RED_COLOR="[31m"
if [ `id -u` == '0' ]; then
  MITSUHIKOS_USER_COLOR=$MITSUHIKOS_RED_COLOR
else
  MITSUHIKOS_USER_COLOR=$MITSUHIKOS_PINK_COLOR
fi

MITSUHIKOS_VC_PROMPT=$' on \033[34m%n\033[00m:\033[00m%b\033[32m%m%u'
MITSUHIKOS_VC_PROMPT_EX="$MITSUHIKOS_VC_PROMPT%m%u"

mitsuhikos_vcprompt() {
  path=`pwd`
  prompt="$MITSUHIKOS_VC_PROMPT"
  vcprompt -f "$prompt"
}

mitsuhikos_lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo -n $'\033[37m exited \033[31m'
    echo -n $code
    echo -n $'\033[37m'
  fi
}

mitsuhikos_backgroundjobs() {
  jobs|python -c 'if 1:
    import sys
    items = ["\033[36m%s\033[37m" % x.split()[2]
             for x in sys.stdin.read().splitlines()]
    if items:
      if len(items) > 2:
        string = "%s, and %s" % (", ".join(items[:-1]), items[-1])
      else:
        string = ", ".join(items)
      print "\033[37m running %s" % string
  '
}

mitsuhikos_virtualenv() {
  if [ x$VIRTUAL_ENV != x ]; then
    if [[ $VIRTUAL_ENV == *.virtualenvs/* ]]; then
      ENV_NAME=`basename "${VIRTUAL_ENV}"`
    else
      folder=`dirname "${VIRTUAL_ENV}"`
      ENV_NAME=`basename "$folder"`
    fi
    echo -n $' \033[37mworkon \033[31m'
    echo -n $ENV_NAME
    echo -n $'\033[00m'
  fi
}

export MITSUHIKOS_BASEPROMPT='\n\e${MITSUHIKOS_USER_COLOR}\u \
\e${MITSUHIKOS_GRAY_COLOR}at \e${MITSUHIKOS_ORANGE_COLOR}\h \
\e${MITSUHIKOS_GRAY_COLOR}in \e${MITSUHIKOS_GREEN_COLOR}\w\
`mitsuhikos_lastcommandfailed`\
\e${MITSUHIKOS_GRAY_COLOR}`mitsuhikos_vcprompt`\
`mitsuhikos_backgroundjobs`\
`mitsuhikos_virtualenv`\
\e${MITSUHIKOS_DEFAULT_COLOR}'
export PS1="${MITSUHIKOS_BASEPROMPT}
$ "

# don't let virtualenv show prompts by itself
VIRTUAL_ENV_DISABLE_PROMPT=1

# startup virtualenv-burrito
if [ -f $HOME/.venvburrito/startup.sh ]; then
    . $HOME/.venvburrito/startup.sh
fi

export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

export FIGNORE=.un~:.swp~

export PYTHONSTARTUP=~/.pythonrc.py

export LESS_TERMCAP_us=$'\e[32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS=-R

## hub
## <https://github.com/defunkt/hub>
eval "$(hub alias -s)"
if [ -f $HOME/.hub.bash_completion.sh ]; then
    source $HOME/.hub.bash_completion.sh
fi
