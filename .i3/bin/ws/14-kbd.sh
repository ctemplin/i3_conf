#!/usr/bin/bash

source ~/.bashrc.d/i3-current-workspace.sh
export WS=14;
export CWS=$(i3-ws-num);

if test $CWS -ne $WS ; then i3-msg workspace number $WS; fi;

# Only populate if current tree is empty (1 line)
if test `i3-save-tree --workspace ${WS} | wc -l` -lt 2 ; then 
  # Nerd Font char UxF11C in string below
  i3-msg rename workspace to "\"`echo -e ${WS}:kbd`\""
  # i3-msg rename workspace to "${WS}:kbd"
  i3-msg append_layout "~/.i3/ws/workspace-${WS}-kbd.jsonc"
  wally &
  brave --new-window --user-data-dir=${HOME}/.config/chromium-kbd/ --app=file:///${HOME}/Pictures/qwerty.png &
  urxvtc &
  brave --new-window --user-data-dir=${HOME}/.config/chromium-kbd/ --app=https://configure.zsa.io/my_layouts &
  #i3-msg '[title="^Oryx"] focus'
else 
  notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
fi

