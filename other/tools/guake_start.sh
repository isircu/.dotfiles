#!/bin/sh

/usr/bin/guake &
sleep 2
guake -r "omnicli" -e "cdomni && git pull -r && repo sync"
guake -n " " -r "fly" -e "cdfly && git pull -r && repo sync"

guake -n " " -r "tcpclient" -e "tmux"
sleep 1
guake -n " " -e "cd && tmux_setup.sh && exit"
guake -s 2
