#!/usr/bin/bash

# Called by .i3/config.
# Starts a nvm-installed i3-shade with nested exempt-callback script

#shellcheck disable=SC1090
source ~/.bashrc.d/nvm.bash && \
i3-shade \
    --urgent \
    --exemptCallbackExec="  source ~/.bashrc.d/i3-current-workspace.sh && \
                            i3-notify-has-mark _shade_exempt \
                            'i3-shade: Disabled' \
                            'i3-shade: Enabled'"