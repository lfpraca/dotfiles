#!/bin/sh
killall -q polybar

# Wait
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch
polybar main &
