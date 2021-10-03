#!/usr/bin/bash

source ~/.bashrc.d/i3-current-workspace.sh
export WS=14;
export CWS=$(i3-ws-num);

if test $CWS -ne $WS ; then i3-msg workspace number $WS; fi;

# Only populate if current tree is empty (1 line)
if test `i3-save-tree --workspace ${WS} | grep -c .` -lt 2 ; then 
  # TerminessTFF Nerd Font char UxF812 in string below
  i3-msg rename workspace to "\"`echo -e ${WS}:kbd`\""
  # i3-msg rename workspace to "${WS}:kbd"
  i3-msg append_layout "~/.i3/ws/workspace-${WS}-kbd.jsonc"
  brave --new-window --app=https://configure.zsa.io/my_layouts &
  wally &
  urxvtc &
else 
  notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
fi

