################################################################################
##
## Alces Clusterware - Cinnamon desktop session script
## Copyright (c) 2016 Alces Software Ltd
##
################################################################################
require process
require distro
require xdg

# 'Xterm*vt100.pointerMode: 0' is to ensure that the pointer does not
# disappear when a user types into the xterm.  In this situation, some
# VNC clients experience a 'freeze' due to a bug with handling
# invisible mouse pointers (e.g. OSX Screen Sharing).
echo 'XTerm*vt100.pointerMode: 0' | process_run xrdb -merge
process_run "${cw_ROOT}"/opt/tigervnc/bin/vncconfig -nowin &
# Disable cinnamon-screensaver
process_run gsettings set org.cinnamon.desktop.screensaver idle-activation-enabled false
# Disable (non-functional) shutdown/hibernate options
process_run gsettings set org.cinnamon.desktop.session session-manager-uses-logind false

install_geometry_script() {
  local f destdir geom_sh

  f="clusterware-geometry.sh"
  if ! geom_sh=$(xdg_data_search clusterware/bin/$f); then
      destdir="$(xdg_data_home)/clusterware/bin"
      geom_sh="${destdir}/${f}"
      mkdir -p "${destdir}"
      cp "${cw_ROOT}"/etc/sessions/cinnamon/${f} "${geom_sh}"
      chmod 755 "${geom_sh}"
  fi

  f="clusterware-geometry.desktop"
  if ! xdg_config_search autostart/$f; then
      destdir="$(xdg_config_home)/autostart"
      mkdir -p "$destdir"
      cp "${cw_ROOT}"/etc/sessions/cinnamon/${f}.tpl "${destdir}/${f}"
      sed -i -e "s,_CLUSTERWARE_GEOMETRY_SH_,${geom_sh},g" "${destdir}/${f}"
  fi
}

if distro_is el7; then
  install_geometry_script
fi

if [ "$1" ]; then
  process_run "$@" &
fi

# Derived from `cinnamon2d`
export CLUTTER_PAINT=disable-clipped-redraws:disable-culling
export LIBGL_ALWAYS_SOFTWARE=1
export CINNAMON_SOFTWARE_RENDERING=1
export CINNAMON_2D=1
export CINNAMON_SLOWDOWN_FACTOR=0.0001
export MUFFIN_NO_SHADOWS=1
export CLUTTER_DEFAULT_FPS=15
cinnamon-session

