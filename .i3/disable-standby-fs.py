#!/usr/bin/env python3

from argparse import ArgumentParser
from subprocess import call
import i3ipc

i3 = i3ipc.Connection()

parser = ArgumentParser(prog='disable-standby-fs',
        description='''
        Disable standby (dpms) and screensaver when a window becomes fullscreen
        or exits fullscreen-mode. Requires `xorg-xset`.
        ''')

args = parser.parse_args()


def find_fullscreen(con):
    # XXX remove me when this method is available on the con in a release
    return [c for c in con.descendants() if c.type == 'con' and c.fullscreen_mode]

def on_fullscreen_mode(i3, e):
    if len(find_fullscreen(i3.get_tree())):
        # call(['xset', 's', 'off'])
        # call(['xset', '-dpms'])
        call(['notify-send', 'Screen Lock Disabled'])
        call(['xautolock', '-disable'])
    else:
        # call(['xset', 's', 'on'])
        # call(['xset', '+dpms'])
        call(['notify-send', 'Screen Lock Enabled'])
        call(['xautolock', '-enable'])

def on_window_close(i3, e):
    if not len(find_fullscreen(i3.get_tree())):
        # call(['xset', 's', 'on'])
        # call(['xset', '+dpms'])
        call(['notify-send', 'Screen Lock Enabled'])
        call(['xautolock', '-enable'])

i3.on('window::fullscreen_mode', on_fullscreen_mode)
i3.on('window::close', on_window_close)

i3.main()
