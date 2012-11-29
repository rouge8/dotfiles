# dotfiles

This is [my](http://andyfreeland.net) collection of dotfiles. It's
managed by a [`dotfiles`](https://github.com/rouge8/dotfiles-base/)
script that automatically symlinks files into `$HOME` from multiple
dotfiles repositories.

## Installation

To install, you must already have the
[`dotfiles`](https://github.com/rouge8/dotfiles-base/) script
installed.  Then, just clone the repo and run:

    $ dotfiles install

# System Setup

The [`setup`](https://github.com/rouge8/dotfiles/tree/master/setup)
directory contains scripts to setup my basic dev environment for Mac or
Ubuntu.

The Ubuntu script assumes internet and sudo access, and the Mac script assumes internet and sudo access as well as XCode's Command Line Tools.

Run [`setup.sh`](http://andyfreeland.net/setup.sh) to install. Does **not** require git to work.
