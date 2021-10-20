#!/usr/bin/bash

i3-config-gen ()
{

  local CONFIG_TMPL=~/.i3/config.tmpl
  local WORK_FILE=~/.i3/config-gen-output/config.temp
  local CONFIG_FILE=~/.i3/config-gen-output/config

  /usr/bin/cp ${CONFIG_TMPL} ${WORK_FILE}

  local WS_NUM

  declare -a WS_KEYS=(1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0)

  # extract the work space key number (2 for each w/w\o Ctrl)
  # Define the magic beginning and ending comments
  local START_LINE_PRTL='# BEGIN WORKSPACE ORDER'
  local END_LINE_PRTL='# END WORKSPACE ORDER'

  # Get the line number of the beginning comment
  read -r -d ':' LINE_NUM <<< "$(grep -no "${START_LINE_PRTL}" ${CONFIG_TMPL})"

  # Read the line between into an array
  mapfile -t WS_NAMES< <(grep -Pzo "(?s)${START_LINE_PRTL}\N*.\K(.*)(?=\N*.${END_LINE_PRTL})" ${CONFIG_TMPL})

  # Loop through the array by index
  local i
  for i in "${!WS_NAMES[@]}"; do
    local WS_NUM=$(( i + 1 ))
    local WS_KEY=${WS_KEYS[$i]}
    if (( i > 9 )); then WS_KEY="Ctrl+${WS_KEY}"; fi

    # format the number and name into the new workspace name
    printf -v WS_FULLNAME "%s:%s" $WS_NUM "${WS_NAMES[$i]}"
    printf -v BINDSYM_COMS \
    "bindsym \$mod+%s workspace \\\"%s\\\";\\\n\
bindsym \$mod+Shift+%s move container to workspace \\\"%s\\\"; workspace \\\"%s\\\";"\
    "$WS_KEY" "$WS_FULLNAME" "$WS_KEY" "$WS_FULLNAME" "$WS_FULLNAME"

    # Extract the text label (just the ascii no ##: or glyph)
    local WS_LABEL
    WS_LABEL=$(echo "${WS_NAMES[$i]}" | jq -Rr '. | match( "(?>\\P{In_Basic_Latin}*)\\K([\\p{ASCII}\\s]+)" ) | .captures[0].string ')

    # rename existing workspace with same number but different name
    local WS_OLD_FULLNAME
    WS_OLD_FULLNAME=$(i3-msg -t get_workspaces | jq -cr --argjson num ${WS_NUM} --arg name "${WS_FULLNAME}" '.[] | select(.num == $num) | select(.name != $name ) | .name')
    if [[ -n $WS_OLD_FULLNAME ]]; then i3-msg "rename workspace \"${WS_OLD_FULLNAME}\" to \"${WS_FULLNAME}\""; fi

    # Replace the "{{{label}}}"" tokens with the workspace full names
    sed -i -e "s/{{{${WS_LABEL}}}}/\"${WS_FULLNAME}\"/g" ${WORK_FILE}
    # Insert bindSym commands. 2 = # of lines in BINDSYM_COMS. TODO: de-magic
    sed -i -e "$(( i * 2 + LINE_NUM  + 1 ))s/^.*$/${BINDSYM_COMS}/" ${WORK_FILE}

  done
  /usr/bin/cp --backup=t ${WORK_FILE} ${CONFIG_FILE}
  rm ${WORK_FILE}
  i3-msg reload
}
i3-config-gen