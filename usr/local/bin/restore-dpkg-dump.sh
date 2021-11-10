#!/bin/bash

OIFS=$IFS
IFS=$'\n'

if [[ -z $@ ]];
then
  echo "Syntax $(basename $0) [dpkg-dump]";
  echo
  echo "This tool simplifies restore of a dokg-dump created using dpkg --get-selections";
  exit 1;
fi

declare -a packages=$(cat ${1} | sed -e 's/\s\s\s/ /g' -e 's/\s\s/ /g' -e 's/\s/ /g')

declare -a installPackages;
declare -a deinstallPackages;

for line in $packages;
do
   pkgs=$(echo $line | cut -d ' ' -f 1);
   cmd=$(echo $line | cut -d ' ' -f 2);

   case $cmd in
     install)
        installPackages+=(${pkgs});
     ;;

     deinstall)
        deinstallPackages+=(${pkgs});
     ;;
   esac
done

if [[ ! -z ${installPackages[@]} ]];
then
  echo ${installPackages[@]} | xargs aptitude install -y;
fi

if [[ ! -z ${deinstallPackages[@]} ]];
then
  echo ${deinstallPackages[@]} | xargs aptitude install -y;
fi

IFS=$OIFS;
