#!/bin/bash
# argument ist die ID oder -name statt -id, dann kann der window name angegeben werden
# mit $(xdotool getactivewindow) bekommt man das gerade aktive fenster
{ read __ WIDTH; read __ HEIGHT; read __ __ BORDER_WIDTH; } < <(xwininfo -id $1 | grep -o -e 'Height:.*' -e 'Width:.*' -e 'Border width:.*')
echo $HEIGHT
echo $WIDTH
echo $BORDER_WIDTH
