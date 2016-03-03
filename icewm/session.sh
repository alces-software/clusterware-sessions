################################################################################
##
## Alces Clusterware - Basic IceWM session script
## Copyright (c) 2016 Alces Software Ltd
##
################################################################################
require process

# 'Xterm*vt100.pointerMode: 0' is to ensure that the pointer does not
# disappear when a user types into the xterm.  In this situation, some
# VNC clients experience a 'freeze' due to a bug with handling
# invisible mouse pointers (e.g. OSX Screen Sharing).
echo 'XTerm*vt100.pointerMode: 0' | process_run xrdb -merge
process_run "${cw_ROOT}"/opt/tigervnc/bin/vncconfig -nowin &

process_run xsetroot -solid '#081f2e'
xterm &
icewm
