#!/bin/bash

function isHardlink()
{
  if [ ! -f "${2}" ];
  then
    # Target file does not exist yet!
    return 2;
  fi
  
  # Compare inodes of both files!
  if [[ $(stat -c '%i' "$1") != $(stat -c '%i' "$2") ]];
  then
    return 1;
  fi

  return 0;
}

function archiveCopy()
{
  echo "Copying hardlinked to archive ${2}";

  _targetPath=$(dirname "${2}");
  test -d "${_targetPath}" || mkdir -p "${_targetPath}";

  cp -rpl "${1}" "${2}" || {
    echo "-> \e[31mError!\e[39m";
    return 0;
  }

  return 1;
}
