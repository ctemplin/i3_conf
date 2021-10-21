#!/usr/bin/bash

# Swtich to the first or last workspace, optionally moving the focused container
# too.
main ()
{
  if [ "$1" == "focus" ]; then ACTION=""; else ACTION="move"; fi

  readarray WS_MIN_MAX <<< "$(i3-msg -t get_workspaces | jq -rc '[.[].num] | min, max')"
  local -A INDICIES=( [first]=0 [last]=1 )
  INDEX=${INDICIES["$2"]}

  local BAF=""
  if [ $ACTION == "move" ]; then
    # Command to follow moved container. Simple but not explicit, some configs 
    # might require a different command.
    BAF="workspace back_and_forth;"
  fi
  i3-msg "$ACTION workspace number ${WS_MIN_MAX[$INDEX]}; $BAF"
}
main "$@"