#!/usr/bin/bash

main () 
{
  # shellcheck source=/dev/null
  source ~/.bashrc.d/i3-current-workspace.sh
  WS=$1;
  CWS=$(i3-ws-name);

  # shellcheck disable=SC2086
  if test $CWS != $WS ; then i3-msg workspace $WS; fi;

  # Only populate if current tree is empty (1 line)
  if test "$(i3-save-tree --workspace "${WS}" | wc -l)" -lt 2 ; then 
    i3-msg append_layout "${HOME}/.i3/ws/workspace-terms.jsonc"
    urxvtc &
    urxvtc &
    urxvtc &
    urxvtc &
  else 
    notify-send -u critical -t 3000 "Workspace #${WS} isn't empty"
  fi
}
main "$@"