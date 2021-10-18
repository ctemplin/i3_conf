#!/usr/bin/bash

source ~/.bashrc.d/i3-current-workspace.sh
WS=$1;
CWS=$(i3-ws-name);

if test $CWS != $WS ; then i3-msg workspace $WS; fi;

# Only populate if current tree is empty (1 line)
if test `i3-save-tree --workspace ${WS} | wc -l` -lt 2 ; then 
  i3-msg append_layout "~/.i3/ws/workspace-ref.jsonc"
  # Custom config for ref bookmarks? --user-data-dir=${HOME}/.config/chromium-ref/
  brave --new-window "file:///$HOME/ref-bookmarks.html" &
  urxvtc -e bash -i -c "eman bash" &
else 
  notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
fi

