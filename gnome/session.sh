################################################################################
##
## Alces Clusterware - GNOME desktop session script
## Copyright (c) 2015 Alces Software Ltd
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
# Disable gnome-screensaver
process_run gconftool-2 --set -t boolean /apps/gnome-screensaver/idle_activation_enabled false

install_background_script() {
  local f destdir geom_sh

  if distro_is el7 || distro_is ubuntu1604; then
      if [ -f "${cw_ROOT}"/etc/theme.rc ]; then
          . "${cw_ROOT}"/etc/theme.rc
      fi
      if [ -f "${cw_ROOT}"/etc/assets/backgrounds/${cw_THEME_bg_image:-default.jpg} ]; then
          f="clusterware-background.sh"
          if ! bg_sh=$(xdg_data_search clusterware/bin/$f); then
              destdir="$(xdg_data_home)/clusterware/bin"
              bg_sh="${destdir}/${f}"
              mkdir -p "${destdir}"
              sed -e "s,_ROOT_,${cw_ROOT},g" \
                  -e "s,_IMAGE_,${cw_THEME_bg_image:-default.jpg},g" \
                  "${cw_ROOT}"/etc/sessions/gnome/${f}.tpl > "${bg_sh}"
              chmod 755 "${bg_sh}"
          fi

          f="clusterware-background.desktop"
          if ! xdg_config_search autostart/$f; then
              destdir="$(xdg_config_home)/autostart"
              mkdir -p "$destdir"
              cp "${cw_ROOT}"/etc/sessions/gnome/${f}.tpl "${destdir}/${f}"
              sed -i -e "s,_CLUSTERWARE_BACKGROUND_SH_,${bg_sh},g" "${destdir}/${f}"
          fi
      fi
  fi
}

install_geometry_script() {
  local f destdir geom_sh

  if distro_is el7 || distro_is ubuntu1604; then
    f="clusterware-geometry.sh"
    if ! geom_sh=$(xdg_data_search clusterware/bin/$f); then
      destdir="$(xdg_data_home)/clusterware/bin"
      geom_sh="${destdir}/${f}"
      mkdir -p "${destdir}"
      cp "${cw_ROOT}"/etc/sessions/gnome/${f} "${geom_sh}"
      chmod 755 "${geom_sh}"
    fi

    f="clusterware-geometry.desktop"
    if ! xdg_config_search autostart/$f; then
      destdir="$(xdg_config_home)/autostart"
      mkdir -p "$destdir"
      cp "${cw_ROOT}"/etc/sessions/gnome/${f}.tpl "${destdir}/${f}"
      sed -i -e "s,_CLUSTERWARE_GEOMETRY_SH_,${geom_sh},g" "${destdir}/${f}"
    fi
  fi
}

# Create flag file to skip initial setup
mark_initial_setup_done() {
  local setup_file
  setup_file="$(xdg_config_home)/gnome-initial-setup-done"
  if [ ! -f "${setup_file}" ]; then
    echo -n "yes" > "${setup_file}"
  fi
}

if distro_is el7 || distro_is ubuntu1604; then
    install_geometry_script
    install_background_script
    mark_initial_setup_done
    export GNOME_SHELL_SESSION_MODE=classic
    _GNOME_PARAMS="--session=gnome-classic"
fi

if [ "$1" ]; then
  process_run "$@" &
fi

gnome-session ${_GNOME_PARAMS}
