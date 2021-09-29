#!/usr/bin/bash

notify-send "Marks:" `i3-msg -t get_marks | jq -rj '.[] | ("<b>" + . + "</b>\\\\n")'`
