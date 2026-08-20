#!/bin/bash

which https > /dev/null || {
  echo "Please install httpie (apt-get install httpie)";
  exit 1;
}

if [[ -z "${@}" ]];
then
  echo "Syntax: $(basename $0) {url}";
  exit 1;
fi

https ${1} -v --verify no --headers --max-redirects 10 -F | grep -oP '^(HTTP|Location:)[^\r\n]+'

exit $?
