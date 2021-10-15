#!/usr/bin/bash

i3-config-toggle-ws-numbers ()
{
  # Show/hide workspace numbers
  local configFile=~/.i3/config-gen-output/config
  local curStripNum=$(grep -Po "strip_workspace_numbers\s+\K(\w+)" ${configFile})
  declare -A vals=( [yes]="no" [no]="yes" )
  local newStripNum=${vals[$curStripNum]}
  sed -i -e "s/strip_workspace_numbers .*/strip_workspace_numbers ${newStripNum}/" ${configFile}
  i3-msg reload
  return 0
}
i3-config-toggle-ws-numbers