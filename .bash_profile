# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

if [[ `hostname -f` != "*.mathcs.carleton.edu" ]]
then
    PATH=$PATH:$HOME/bin:$HOME/local/node/bin
    export GOROOT=$HOME/local/go
    export PATH=$PATH:$GOROOT/bin
else
    PATH=$HOME/local-mac/bin:$PATH:$HOME/bin:$HOME/.gem/ruby/1.8/bin
fi


export PATH
unset USERNAME
export TERM=xterm
export EDITOR=vim

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1="\[\e]0;\u@\h: \w\a\][\u@\h \w]\$ "

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

source $HOME/.leiningen_completion.bash

# startup virtualenv-burrito
if [ -f $HOME/.venvburrito/startup.sh ]; then
    . $HOME/.venvburrito/startup.sh
fi

export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

export FIGNORE=.un~:.swp~
