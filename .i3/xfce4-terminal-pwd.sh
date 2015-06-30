#!/bin/bash

# Little script hack that mimics pwdx with xfce4-terminal (all of
# whose windows share a single process for perfomance) by extracting
# the cwd from the window title.  If the ACTIVE_WINDOW isn't a
# xfce4-terminal, return pwdx of the current window's PID.
id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
class_string=$(xprop -id $id | awk '/WM_CLASS\(STRING\)/' | cut -d'=' -f2 | cut -d',' -f1)
if [ $class_string != '"xfce4-terminal"' ]
    then
        pid=$(xprop -id $id | awk '/_NET_WM_PID\(CARDINAL\)/' | cut -d'=' -f2)
        echo `pwdx $pid` | cut -d':' -f2 | cut -d' ' -f2
    else
        name=$(xprop -id $id | awk '/_NET_WM_NAME/' | cut -d'"' -f2 | cut -d" " -f4 );
        name=$(echo "$name" | sed "s|~|$HOME|" )
        echo $name
fi
