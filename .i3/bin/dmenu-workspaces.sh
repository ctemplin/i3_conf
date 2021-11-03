#!/usr/bin/bash

main ()
{
  source ~/.bashrc.d/pointer.sh
  get_display_dimensions;

  local WS_NAME
  WS_NAME=$(i3-msg -t get_workspaces | jq -r ' .[] | .name ' | dmenu -l 20 -w 100 -x $(( RES_X/2 - 50 )) -y 200)
  i3-msg workspace "$WS_NAME"
}
main "$@"