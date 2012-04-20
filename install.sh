#!/bin/bash

DOTFILES=$(cd "$(dirname "$0")"; pwd)
source "$DOTFILES"/dotfiles_config

installFile(){
    if [ -L ~/$1 -o -f ~/.olddotfiles/$1 -o -d ~/.olddotfiles/$1 ]; then
        echo A link to $1 already exists.  Something is wrong.
    else
        mv ~/$1 ~/.olddotfiles/$1
        ln -s "$DOTFILES"/$1 ~/$1
    fi
}

if [ -d ~/.olddotfiles ]
    then
        echo "There is an older version of backedup dot files.  Please run the uninstall before you install again."
    else
        mkdir ~/.olddotfiles
        for file in $FILES; do
            installFile $file
        done

        if [ ! -d $HOME/bin ]; then
            mkdir -p $HOME/bin
        fi

        for file in $DOTFILES/bin/*; do
            ln -s $file $HOME/bin/
        done
fi
