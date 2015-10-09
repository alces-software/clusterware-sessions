current_geometry=$(xrandr -q | awk -F 'current' -F',' 'NR==1 {gsub("( |current)",""); print $2}')
if [ "$current_geometry" != "${cw_SESSION_GEOMETRY:-1024x768}" ] ; then
    xrandr --output VNC-0 --mode ${cw_SESSION_GEOMETRY:-1024x768}
fi
