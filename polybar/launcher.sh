#!/usr/bin/env bash

dir="$HOME/.config/polybar"
config="$dir/config.ini"

killall -q polybar

polybar -c "$config" bar1 & disown
polybar -c "$config" bar2 & disown
