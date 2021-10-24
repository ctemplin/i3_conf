#!/usr/bin/bash

# Toggle between 2 of the 3 border states (pixel and normal)
# Will come out of 3rd state (none) but not re-enter

i3-border-toggle-partial ()
{
  local -A NEXTBORDER
  NEXTBORDER=( [none]="normal" [pixel]="normal" [normal]="pixel" )
  local CURBORDER
  CURBORDER=$(i3-msg -t get_tree | jq -j ' recurse((.nodes, .floating_nodes)[]) | select(.focused == true) | .border')
  i3-msg border "${NEXTBORDER[${CURBORDER}]}"
}

i3-border-toggle-partial
