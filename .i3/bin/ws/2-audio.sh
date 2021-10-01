#!/usr/bin/bash

source ~/.bashrc.d/i3-current-workspace.sh
export WS=2;
export CWS=$(i3-ws-num);

if test $CWS -ne $WS ; then i3-msg workspace number $WS; fi;

# Only populate if current tree is empty (1 line)
if test `i3-save-tree --workspace ${WS} | grep -c .` -lt $WS ; then 
  i3-msg rename workspace to "${WS}:audio"
  i3-msg append_layout "~/.i3/ws/workspace-${WS}-audio.jsonc"
  pavucontrol &
  blueman-manager &
  urxvtc &
else 
  notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
fi
