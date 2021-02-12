#!/bin/bash

[[ -z "$@" ]] && {
  echo "Syntax $(basename $0) {source} {target}";
  echo "  > source and target can be block-device or directory";
  echo "  > block device mount-point will be resolved";
  echo;

  exit 1;
}

source="${1}";
target="${2}";

[[ -d "${source}" || -b "${source}" ]] || {
  echo "[!] Error: Source must be directory or block-device!";
  exit 1;
}

[[ -d "${target}" || -b "${target}" ]] || {
  echo "[!] Error: Target must be directory or block-device!";
  exit 1;
}

function resolveMountPoint()
{
  [[ -b "${1}" ]] || return 1;
  findmnt --source "${1}" --output TARGET --first-only --noheadings || return 1;
  return 0;
}

function resolvePath()
{
  path='';
  if [[ -d "${1}" ]];
  then
    path=$(realpath "${1}")/;
  elif [[ -b "${1}" ]];
  then
    path=$(realpath $(resolveMountPoint "${1}"))/;
  fi

  path=${path/\/\///};

  [[ -z "${path}" || ! -d "${path}" ]] && return 1;

  echo "${path}";
  return 0;
}

#function writeMountMetaKey()
#{
#  local file="${targetPath}/.mount-point";
#  [[ -f "${file}" ]] || echo "{}" > "${file}";
#  json=$(printf '".%s=\\"%s\\""' "${1}" "${2}");
#echo "test: $json";
#exit
#  jq -n "${json}" "${file}" > "${file}.lock" \
#  && mv "${file}.lock" "${file}" \
#  && return 0;
#}

function getMountMetaKey()
{
  [[ -f "${targetPath}/.mount-point" ]] || return 0;
  source <(grep "${1}" "${targetPath}/.mount-point");

  local ref="${1}";
  local value="${ref}";
  [[ -z "${!value}" ]] && return 1;

  echo "${!value}";
  return 0;
}

function checkMountMetaFile()
{
  [[ -f "${targetPath}/.mount-point" ]] || return 0;

  mountPath=$(getMountMetaKey 'mountpoint');
  sourcePath=$(realpath "${sourcePath}");
  [[ -z "${mountPath}" ]] && return 0;
  [[ "${mountPath}" == "${sourcePath}" ]] && return 0;

  # Convert old File
  echo $(cat "${targetPath}/.mount-point") == "${sourcePath}"
  if [[ $(cat "${targetPath}/.mount-point") == "${sourcePath}" ]];
  then
    printf "[i] Converting plain mount-meta file to new format!\n";
    mountPath=$(cat "${targetPath}/.mount-point");
    printf 'mountpoint=%s' "${mountPath}" > "${targetPath}/.mount-point";
    #writeMountMetaKey 'mount.path' "${mountPath}";
  fi

  # ERROR!
  printf "[!] Mount-Meta mount-point mismatching source-path!\n";
  printf "    %s <> %s\n" "${mountPath}" "${sourcePath}";
  return 1;
}

sourcePath=$(resolvePath "${source}");
[[ -z "${sourcePath}" || ! -d "${sourcePath}" ]] && {
  echo "[!] Error: Cannot resolve source path! (got '${sourcePath}')";
  exit 1;
}

targetPath=$(resolvePath "${target}");
[[ -z "${targetPath}" || ! -d "${targetPath}" ]] && {
  echo "[!] Error: Cannot resolve source path! (got '${targetPath}')";
  exit 1;
}

[[ -f "${targetPath}/.mount-point" ]] && {
  printf "[i] Found .mount-point Meta-File on target\n";

  checkMountMetaFile && echo "Check Ok" || {
    echo "[!] Quit!";
    exit 1;
  }
}

echo;
echo "Rsync ${sourcePath} -> ${targetPath}";
echo;
read -p "Are you sure? " -n 1 -r;
[[ $REPLY =~ ^[Yy]$ ]] || { echo "exit!"; exit 1; }

[[ -f "${targetPath}" ]] || echo "${sourcePath}" > "${targetPath}/.mount-point";

rsync \
  -ahPHAXx \
  --progress \
  --delete \
  --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found} \
  --exclude=/.mount-point \
  "${sourcePath}" \
  "${targetPath}" \
  ${@:3} \
;
