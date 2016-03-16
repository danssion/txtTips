#!/bin/sh
#
# name     : tmuxen， tmux environment made easy
# author   : Xu Xiaodong xxdlhy@gmail.com
# license  : GPL
# created  : 2012 Jul 01
# modified : 2012 Jul 02
#

cmd=$(which tmux) # tmux path
session=codeTmux   # session name

if [ -z $cmd ]; then
    echo "You need to install tmux."
    exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
    $cmd new -d -n vim -s $session "vim"
    $cmd splitw -v -p 20 -t $session "pry"
    $cmd neww -n mutt -t $session "mutt"
#    $cmd neww -n irssi -t $session "irssi"
#    $cmd neww -n cmus -t $session "cmus"
    $cmd neww -n zsh -t $session "zsh"
    $cmd splitw -h -p 50 -t $session "zsh"
    $cmd selectw -t $session:5
fi

$cmd att -t $session

exit 0  
