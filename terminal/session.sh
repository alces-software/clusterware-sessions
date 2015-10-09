################################################################################
##
## Alces Clusterware - Basic terminal session script
## Copyright (c) 2015 Alces Software Ltd
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
xterm \
    -ls -title "Alces Clusterware terminal session: $USER" \
    -rightbar \
    -xrm 'xterm*pointerMode: 0' \
    -xrm 'xterm*loginShell: true' \
    -xrm 'xterm*vt100*geometry: 143x58+3+2' \
    -xrm 'xterm*saveLines: 2000' \
    -xrm 'xterm*charClass: 33:48,35:48,37:48,43:48,45-47:48,64:48,95:48,126:48,35:48' \
    -xrm 'xterm*termName: xterm-color' \
    -xrm 'xterm*eightBitInput: false' \
    -xrm 'xterm*borderWidth:0' \
    -xrm 'xterm*foreground: rgb:a8/a8/a8' \
    -xrm 'xterm*background: rgb:08/1f/2e' \
    -xrm 'xterm*color0: rgb:00/00/00' \
    -xrm 'xterm*color1: rgb:a8/00/00' \
    -xrm 'xterm*color2: rgb:00/a8/00' \
    -xrm 'xterm*color3: rgb:a8/54/00' \
    -xrm 'xterm*color4: rgb:40/40/a8' \
    -xrm 'xterm*color5: rgb:a8/00/a8' \
    -xrm 'xterm*color6: rgb:00/a8/a8' \
    -xrm 'xterm*color7: rgb:a8/00/00' \
    -xrm 'xterm*color8: rgb:54/54/54' \
    -xrm 'xterm*color9: rgb:fc/54/54' \
    -xrm 'xterm*color10: rgb:54/fc/54' \
    -xrm 'xterm*color11: rgb:fc/fc/54' \
    -xrm 'xterm*color12: rgb:54/54/fc' \
    -xrm 'xterm*color13: rgb:fc/54/fc' \
    -xrm 'xterm*color14: rgb:54/fc/fc' \
    -xrm 'xterm*color15: rgb:fc/fc/fc' \
    -xrm 'xterm*boldMode: false' \
    -xrm 'xterm*font: -*-fixed-medium-r-*-*-*-120-*-*-*-*-*-*' \
    -xrm 'xterm*boldFont: -*-fixed-medium-r-*-*-*-120-*-*-*-*-*-*' \
    -xrm 'xterm*colorBDMode: true' \
    -xrm 'xterm*colorBD: rgb:fc/fc/fc' \
    -xrm 'xterm*highlightSelection: true' \
    -xrm 'xterm.VT100*colorULMode: on' \
    -xrm 'xterm.VT100*underLine: off' \
    -xrm 'xterm*VT100*colorUL: rgb:a8/00/a8' \
    -xrm 'xterm*scrollBar: true' \
    -xrm 'xterm*scrollBar.width: 24' \
    -xrm 'xterm.VT100.titeInhibit: true' \
    -xrm 'xterm.VT100*dynamicColors: on' \
    -xrm 'xterm*reverseWrap: true' \
    -xrm '*visualBell: false' \
    -xrm '*scrollTtyOutput: false' \
    -xrm '*scrollKey: true' \
    -xrm 'Scrollbar.JumpCursor: true' \
    -xrm 'xterm.*backarrowKey: true' \
    -xrm 'xterm*VT100.translations: #override Shift Ctrl <Key>V: insert-selection(PRIMARY)'
