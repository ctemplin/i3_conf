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

  # shellcheck source=/dev/null
  source ~/.bashrc.d/pointer.sh
  get_display_dimensions;

  case $1 in
    northwest)
      i3-msg move position 0 px 0 px
      ;;
    north)
      i3-msg move position $((RES_X/2 - WIN_WIDTH/2)) px 0 px
      ;;
    northeast)
      i3-msg move position $((RES_X - WIN_WIDTH)) px 0 px
      ;;
    west)
      i3-msg move position 0 px $((RES_Y/2 - WIN_HEIGHT/2)) px
      ;;
    center)
      i3-msg move position $((RES_X/2 - WIN_WIDTH/2)) px $((RES_Y/2 - WIN_HEIGHT/2)) px
      ;;
    east)
      i3-msg move position $((RES_X - WIN_WIDTH)) px $((RES_Y/2 - WIN_HEIGHT/2)) px
      ;;
    southwest)
      i3-msg move position 0 px $((RES_Y - WIN_HEIGHT)) px
      ;;
    south)
      i3-msg move position $((RES_X/2 - WIN_WIDTH/2)) px $((RES_Y - WIN_HEIGHT)) px
      ;;
    southeast)
      i3-msg move position $((RES_X - WIN_WIDTH)) px $((RES_Y - WIN_HEIGHT)) px
      ;;
  esac


  return 0;
}
main "$@"