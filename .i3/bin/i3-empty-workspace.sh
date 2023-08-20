#!/usr/bin/bash

# Swtich to the prev or next empty workspace, optionally moving the focused
# container too.
# "Empty" means defined in i3 config file but having no containers so not
# displayed. Numbers are inferred by their absence in the current workspace list.
# Solution extracts bindsym commands from the running config.
# Assumes focus workspace = $mod+[Ctrl+]+<0-9>, and move = $mod+Shift+[Ctrl]+<0-9>
# [Ctrl+] targets workspaces 11-20.

# shellcheck source=/dev/null
source "${HOME}"/.bashrc.d/i3-current-workspace.sh
i3-empty-workspace ()
{
  local MAX_WS_COUNT=20
  if [[ $1 == "focus" ]]; then ACTION=""; else ACTION="move"; fi

  local WSSTR CWS i NUMKEY
  WSSTR=",$(i3-msg -t get_workspaces | jq -cj  ' .[] | .num | tostring | . + "," ')"
  CWS=$(i3-ws-num)
  
  # Decrement/increment(default) from current WS# until we find a missing one.
  if [[ $2 != "prev" ]]; then
    for ((i = $((++CWS)); i <= MAX_WS_COUNT; i++)); do
      if ! [[ $WSSTR =~ ,$i, ]]; then NUMKEY=$i; break; fi
    done
  else
    for ((i = $((--CWS)); i >= 1 ; i--)); do
      if ! [[ $WSSTR =~ ,$i, ]]; then NUMKEY=$i; break; fi
    done
  fi

  local CTRLKEY SHFTKEY
  if [[ -n "$NUMKEY" ]]; then
    # 1-10 and 11-20 use the same keys.
    NUMKEY=$(( "$i" % 10 ))
    CTRLKEY=""; if (( i > 10 )); then CTRLKEY="Ctrl\+"; fi
    SHFTKEY=""; if [[ $ACTION == "move" ]]; then SHFTKEY="Shift\+"; fi
    # Extract the bindsym command from the config and execute it.
    i3-msg "$(i3-msg -t get_config | grep -Po "bindsym\s+\\\$mod\+${SHFTKEY}${CTRLKEY}${NUMKEY}\s+\K(.*)")"
  else
    notify-send --urgency critical -t 1500 "No empty workspace found."
  fi
  return 0
}
i3-empty-workspace "$@"