#!/bin/bash

export MAX_I3_WS_NUM=`i3-msg -t get_workspaces | jq '[.[].num] | max + 1'`
i3-msg move container to workspace $MAX_I3_WS_NUM