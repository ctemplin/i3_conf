#!/usr/bin/bash

i3-config-gen ()
{

  local configTmpl=~/.i3/config.tmpl
  local workFile=~/.i3/config-gen-output/config.temp
  local configFile=~/.i3/config-gen-output/config

  /usr/bin/cp ${configTmpl} ${workFile}

  local wsNum

  declare -a wsKeys=(1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0)

  # extract the work space key number (2 for each w/w\o Ctrl)
  # Define the magic beginning and ending comments
  local START_LINE_PRTL='# BEGIN WORKSPACE ORDER'
  local END_LINE_PRTL='# END WORKSPACE ORDER'

  # Get the line number of the beginning comment
  read -d ':' lineNum <<< $(grep -no "${START_LINE_PRTL}" ${configTmpl})

  # Read the line between into an array
  declare -a wsArr=($(grep -Pzo "(?s)${START_LINE_PRTL}\N*.\K(.*)(?=${END_LINE_PRTL})" ${configTmpl}))

  # Loop through the array by index
  for i in ${!wsArr[@]}; do
    local wsNum=$(( $i + 1 ))
    local wsKey=${wsKeys[$i]}
    if (( $i > 9 )); then wsKey="Ctrl+${wsKey}"; fi

    # format the number and name into the new workspace name
    printf -v wsFormat "%s:%s" $wsNum ${wsArr[$i]}
    printf -v bindSyms \
    "bindsym \$mod+%s workspace \\\"%s\\\";\\\n\
bindsym \$mod+Shift+%s move container to workspace \\\"%s\\\"; workspace \\\"%s\\\";"\
    $wsKey $wsFormat $wsKey $wsFormat $wsFormat

    # Extract the text label (just the ascii no ##: or glyph)
    local wsLabel=$(echo "${wsArr[$i]}" | jq -Rr '. | match( "(?>\\P{In_Basic_Latin}*)\\K([\\p{ASCII}\\s]+)" ) | .captures[0].string ')

    # rename existing workspace with same number but different name
    local curName=`i3-msg -t get_workspaces | jq -cr --argjson num ${wsNum} --arg name ${wsFormat} '.[] | select(.num == $num) | select(.name != $name ) | .name'`
    if [[ -n $curName ]]; then i3-msg "rename workspace \"${curName}\" to \"${wsFormat}\""; fi

    local pat="s/${wsArr[$i]}/${bindSyms}/"
    sed -i -e "s/{{{${wsLabel}}}}/\"${wsFormat}\"/g" ${workFile}
    sed -i -e "$(( $i * 2 + $lineNum  + 1 ))s/^.*$/${bindSyms}/" ${workFile}

  done
  /usr/bin/cp --backup=t ${workFile} ${configFile}
  rm ${workFile}
  i3-msg reload
}
i3-config-gen