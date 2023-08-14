#!/bin/bash
_pwd=$(realpath $(dirname $0))

[ "$EUID" != 0 ] && {
  echo "This script must be run as root!";
  exit 1;
}

[ -L "/etc/profile.d/scratch.sh" ] || {
  ln -s "${_pwd}/scratch.rc" "/etc/profile.d/scratch.sh";
}

[ -L "/etc/sudoers.d/scratch-sudoers" ] || {
  chown root:$USER "${_pwd}/etc/sudoers.d/scratch-sudoers";
  ln -s "${_pwd}/etc/sudoers.d/scratch-sudoers" "/etc/sudoers.d/scratch-sudoers";
}

sudo groupadd scratch-sudoers
sudo usermod -aG scratch-sudoers $USER
