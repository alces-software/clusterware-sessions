################################################################################
##
## Alces Clusterware - Cinnamon desktop session script
## Copyright (c) 2016 Alces Software Ltd
##
################################################################################
require process
require xdg

# 'Xterm*vt100.pointerMode: 0' is to ensure that the pointer does not
# disappear when a user types into the xterm.  In this situation, some
# VNC clients experience a 'freeze' due to a bug with handling
# invisible mouse pointers (e.g. OSX Screen Sharing).
echo 'XTerm*vt100.pointerMode: 0' | process_run xrdb -merge
process_run "${cw_ROOT}"/opt/tigervnc/bin/vncconfig -nowin &

# suppress default first run panel prompt 
destdir="$(xdg_config_home)/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "${destdir}"
cp /etc/xdg/xfce4/panel/default.xml "${destdir}"/xfce4-panel.xml

if [ "$1" ]; then
  process_run "$@" &
fi

unset DBUS_SESSION_BUS_ADDRESS
xfce4-session &

# This dance is to allow us to disable disgusting sub pixel hinting
xfce4_session_pid=$!
while [ -z "$addr" -a -d /proc/$xfce4_session_pid ]; do
    addr=$(grep -z "DBUS_SESSION_BUS_ADDRESS" /proc/$xfce4_session_pid/environ)
    sleep 1
done
if [ "$addr" ]; then
    eval $addr
    export DBUS_SESSION_BUS_ADDRESS
    echo "DBUS: $DBUS_SESSION_BUS_ADDRESS"
    xfconf-query -v -c xsettings -p /Xft/HintStyle -s hintnone
fi
wait
