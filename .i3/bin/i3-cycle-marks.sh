#!/usr/bin/bash

# Cycle forward by default. Any param reverses direction.
if [ -z "$1" ]; then INCVAL=1; else INCVAL=-1; fi

# Fill an array with the current marks.
declare -a "MARK_LIST=(`i3-msg -t get_marks | jq -rj '.[] | (. + " ")'`)"
# Get the the first mark (if any) of the currently focused window.
MARK_OF_FOCUSED=`i3-msg -t get_tree | jq -j ' recurse(.nodes[]) | select(.focused == true) | .marks[0] '`

# Focused window is unmarked; target the first mark in the list.
TARGET_MARK_INDEX=0

# Focused winow is marked; target the next or prev mark.
if [ "$MARK_OF_FOCUSED" != "null" ]
then
  # Find the array index of the current mark.
  for i in "${!MARK_LIST[@]}"; do
    if [[ "${MARK_LIST[$i]}" == "${MARK_OF_FOCUSED}" ]]; then
      # Increment or decrement.
      TARGET_MARK_INDEX=$(( i + INCVAL ));
      # If beyond bound wrap around to beginning of array. No need to reverse
      # wrap to end of array; an index of -1 is equivalent to array length - 1.
      if (( $TARGET_MARK_INDEX >= ${#MARK_LIST[@]} )); then
        TARGET_MARK_INDEX=0
      fi
    fi
  done
fi

# notify-send -u low -t 1500 \
#   "Cycle Target: ${TARGET_MARK_INDEX} ${MARK_LIST[${TARGET_MARK_INDEX}]}"
i3-msg "[con_mark=\"${MARK_LIST[${TARGET_MARK_INDEX}]}\"] focus"