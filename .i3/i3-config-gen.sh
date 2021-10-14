#!/usr/bin/bash

i3-config-gen ()
{
  # "placeholder;layout-tag;number;glyph;label"
  declare -a wsArr=(
    "{{{ws1}}};pkg;1;;pkgs"
    "{{{ws2}}};snd;2;;audio"
    "{{{ws3}}};code;3;謹;code"
    "{{{ws4}}};term;4;‎ﲵ;term"
    "{{{ws5}}};___;5;;___"
    "{{{ws6}}};bar;6;瞧;bar"
    "{{{ws7}}};net;7;;net"
    "{{{ws8}}};web;8;拓;web"
    "{{{ws9}}};___;9;;___"
    "{{{ws10}}};sec;10;聾;sec"
    "{{{ws11}}};___;11;;___"
    "{{{ws12}}};___;12;;___"
    "{{{ws13}}};comm;13;‎שּ;comms"
    "{{{ws14}}};kbd;14;;kbd"
    "{{{ws15}}};ws;15;;ws"
    "{{{ws16}}};ws;16;;ws"
    "{{{ws17}}};ws;17;;ws"
    "{{{ws18}}};ws;18;;ws"
    "{{{ws19}}};ws;19;;ws"
    "{{{ws20}}};ws;20;;ws"
  )

  local configTmpl=~/.i3/config.tmpl
  local workFile=~/.i3/config-gen-output/config.temp
  local configFile=~/.i3/config-gen-output/config

  /usr/bin/cp ${configTmpl} ${workFile}

  # loop through the array of ws tokenized strings
  for wsLine in ${wsArr[@]}; do
    readarray -d ';' -t tokens<<< "$wsLine"

    # format the tokens into the new workspace name
    printf -v wsFormat "%s:%s%s" ${tokens[2]} ${tokens[3]} ${tokens[4]}
    echo $wsFormat

    # rename existing workspace with same number but different name
    local curName=`i3-msg -t get_workspaces | jq -cr --argjson num ${tokens[2]} --arg name ${wsFormat} '.[] | select(.num == $num) | select(.name != $name ) | .name'`
    if [[ -n $curName ]]; then i3-msg "rename workspace \"${curName}\" to \"${wsFormat}\""; fi
    
    sed -i -e "s/${tokens[0]}/\"${wsFormat}\"/g" ${workFile}
  done
  /usr/bin/cp --backup=t ${workFile} ${configFile}
  rm ${workFile}
  i3-msg reload
}
i3-config-gen