#!/usr/bin/bash

main ()
{
  source ~/.bashrc.d/pointer.sh
  get_display_dimensions;

  local WS_NAME
  # Using color values defined in .Xresources via xrdb.
  # These can be autoloaded with a patched version of dmenu.
  # Patch at https://tools.suckless.org/dmenu/patches/xresources/
  WS_NAME=$(i3-msg -t get_workspaces | jq -r ' .[] | .name ' | \
  dmenu -l 20 -w 120 -x $(( RES_X/2 - 50 )) -y 200 \
  -fn "NotoSansMono Nerd Font" \
  -nf "$(xrdb -get dmenu.foreground)" \
  -nb "$(xrdb -get dmenu.background)" \
  -sf "$(xrdb -get dmenu.selforeground)" \
  -sb "$(xrdb -get dmenu.selbackground)" )
  i3-msg workspace "$WS_NAME"
}
main "$@"