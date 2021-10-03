#!/usr/bin/bash

source ~/.bashrc.d/i3-current-workspace.sh
export WS=1;
export CWS=$(i3-ws-num);

if test $CWS -ne $WS ; then i3-msg workspace number $WS; fi;

# Only populate if current tree is empty (1 line)
if test `i3-save-tree --workspace ${WS} | wc -l` -lt 2 ; then 
  # Nerd Font char UxF8D6 pkgs in string below
  i3-msg rename workspace to "\"`echo -e ${WS}: pkgs`\""
  # i3-msg rename workspace to "${WS}:audio"
  i3-msg append_layout "~/.i3/ws/workspace-${WS}-pkgs.jsonc"
  /usr/bin/octopi &
  urxvtc &
  urxvtc &
else 
  notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
fi
