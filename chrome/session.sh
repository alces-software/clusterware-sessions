################################################################################
##
## Alces Clusterware - Google Chrome session script
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

process_run xsetroot -solid '#081f2e'

# Use different directory for each display, otherwise cannot have multiple
# Chrome sessions running at same time as Chrome will detect it is already
# running and open a new tab in the existing session (see
# http://superuser.com/a/491360).
destdir="$(xdg_config_home)/google-chrome/session${DISPLAY}"
if [ ! -d "${destdir}" ]; then
    mkdir -p "${destdir}"
    touch "${destdir}/First Run"
fi

geometry="${cw_SESSION_geometry:-1024x768}"
window_size="$(echo "${geometry}" | sed 's/x/,/' )"

google-chrome \
    --window-position=0,0 \
    --window-size="${window_size}" \
    --user-data-dir="${destdir}"
