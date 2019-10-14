#!/bin/bash
_portainerVolume='portainer-data';

read -s -p "Enter Password: " _pw;
echo;
read -s -p "Confirm Password: " _pwC;
echo;

if [[ -z ${_pw} ]] || [[ -z ${_pwC} ]];
then
  echo "Error empty Password!";
  exit 1;
fi

if [[ ${_pw} != ${_pwC} ]];
then
  echo "Error password & confirm not matching";
  exit 1;
fi

if [[ $(docker container ls | grep portainer -c) > 0 ]];
then
  docker stop portainer && \
  docker rm portainer;
fi

_cryptPw=$(htpasswd -nb -B admin $(echo ${_pw}) | cut -d ":" -f 2);
echo "Encrypted PW: ${_cryptPw}";

docker pull portainer/portainer:latest && \
docker run -d \
  -p 8000:8000 -p 9000:9000 \
  --name portainer --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${_portainerVolume}:/data portainer/portainer \
  --admin-password=${_cryptPw} \
;
