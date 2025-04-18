#!/usr/bin/bash

main ()
{
  # shellcheck source=/dev/null
  source "${HOME}"/.bashrc.d/i3-current-workspace.sh
  
  # short-circuit for non-tiling windows
  FLOATING=$(i3-focused-node-floating)
  if [[ "$FLOATING" == *_off ]]; then
    notify-send --urgency critical -t 1500 "Cannot snap tiling window to edge"
    return 1;
  fi
  
  local WIN_WIDTH WIN_WIDTH BAR_HEIGHT
  WIN_WIDTH=$(i3-focused-node | jq -j .rect.width)
  WIN_HEIGHT=$(i3-focused-node | jq -j .rect.height)
  BAR_HEIGHT=$(i3-focused-node | jq -j .deco_rect.height)
  WIN_HEIGHT=$((WIN_HEIGHT + BAR_HEIGHT))

  # Extract the four resolution/offset values
  local ID PAT
  local -a DIMS
  local RES_X RES_Y OFF_X OFF_Y
  ID=$(i3-focused-node-display)
  PAT="s/${ID} connected (primary )?([0-9]*)x([0-9]*)\+([0-9]*)\+([0-9]*).*/\2 \3 \4 \5/p"
  DIMS=($(xrandr --current | sed -En "${PAT}"))
  RES_X=${DIMS[0]}
  RES_Y=${DIMS[1]}
  OFF_X=${DIMS[2]}
  OFF_Y=${DIMS[3]}


  case $1 in
    northwest)
      i3-msg move position $((0 + OFF_X)) px ${OFF_Y} px
      ;;
    north)
      i3-msg move position $(((RES_X/2 - WIN_WIDTH/2) + OFF_X)) px ${OFF_Y} px
      ;;
    northeast)
      i3-msg move position $(((RES_X - WIN_WIDTH) + OFF_X)) px ${OFF_Y} px
      ;;
    west)
      i3-msg move position ${OFF_X} px $(((RES_Y/2 - WIN_HEIGHT/2) + ${OFF_Y})) px
      ;;
    center)
      i3-msg move position $(((RES_X/2 - WIN_WIDTH/2) + ${OFF_X})) px $(((RES_Y/2 - WIN_HEIGHT/2) + ${OFF_Y})) px
      ;;
    east)
      i3-msg move position $(((RES_X - WIN_WIDTH) + ${OFF_X})) px $(((RES_Y/2 - WIN_HEIGHT/2) + ${OFF_Y})) px
      ;;
    southwest)
      i3-msg move position ${OFF_X} px $(((RES_Y - WIN_HEIGHT) + ${OFF_Y})) px
      ;;
    south)
      i3-msg move position $(((RES_X/2 - WIN_WIDTH/2) + ${OFF_X})) px $(((RES_Y - WIN_HEIGHT) + ${OFF_Y})) px
      ;;
    southeast)
      i3-msg move position $(((RES_X - WIN_WIDTH) + ${OFF_X})) px $(((RES_Y - WIN_HEIGHT) + ${OFF_Y})) px
      ;;
  esac


  return 0;
}
main "$@"