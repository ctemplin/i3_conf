#!/usr/bin/bash

main ()
{
  # shellcheck source=/dev/null
  source "${HOME}"/.bashrc.d/i3-current-workspace.sh
 
   # short-circuit for non-tiling windows
  FLOATING=$(i3-focused-node-floating)
  if [[ "$FLOATING" == *_on ]]; then
    notify-send --urgency critical -t 1500 "Cannot cycle size of floating window"
    return 1;
  fi
  
  # Array of PPT vals to step through
  local -a PPTS=( 9 12 18 24 32 38 50 62 68 76 82 88 91 )
  # Get the current PPT
  CUR_PPT=$(i3-focused-node-ppts)
  # Get the orientation of the focused node's parent.
  # TODO: remove assumption that immediate parent has relevant layout/orientation.
  # TODO: instead walk up node tree until we find appropriate node.
  local PARENT_ORNTN DIM
  PARENT_ORNTN=$(i3-focused-node-parent | jq -r '.orientation')
  if [[ "$PARENT_ORNTN" == "vertical" ]]; then
    DIM="height"
  else
    DIM="width"
  fi
  local PPTS_LEN i TRGT_PPT
  PPTS_LEN=${#PPTS[@]}
  if [[ $1 == "grow" ]]; then
    # Move forward through PPTS
    for ((i = 0; i <= "$PPTS_LEN"; i++)); do
      if (( PPTS[i] > CUR_PPT )); then
        TRGT_PPT="${PPTS[i]}" && break;
      fi
    done
  else
    # Move backward through PPTS
    for ((i = $((--PPTS_LEN)); i >= 0; i--)); do
      if (( PPTS[i] < CUR_PPT )); then
        TRGT_PPT="${PPTS[i]}" && break;
      fi
    done
  fi
  if [[ -n "$TRGT_PPT" ]]; then i3-msg resize set "$DIM" "$TRGT_PPT" ppt; fi
  return 0;
}
main "$@"