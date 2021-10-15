#!/usr/bin/bash

source ~/.bashrc.d/i3-current-workspace.sh
WS=$1;
CWS=$(i3-ws-name);

if test $CWS != $WS ; then i3-msg workspace $WS; fi;

# Only populate if current tree is empty (1 line)
if test `i3-save-tree --workspace ${WS} | wc -l` -lt 2 ; then 
  i3-msg append_layout "~/.i3/ws/workspace-kbd.jsonc"
  wally &
  # http://i.kinja-img.com/gawker-media/image/upload/t_original/936004453291456145.png
  brave --new-window --user-data-dir=${HOME}/.config/chromium-kbd/ --app=file:///${HOME}/Pictures/qwerty.png &
  urxvtc &
  brave --new-window --user-data-dir=${HOME}/.config/chromium-kbd/ --app=https://configure.zsa.io/my_layouts &
  #i3-msg '[title="^Oryx"] focus'
else 
  notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
fi

