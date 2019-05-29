#/bin/bash

declare -i timeout=0;
declare -i isUp=0;
until [[ $isUp -eq 1 || timeout -eq 4 ]];
do
  lsof -Pi TCP:4330 -t > /dev/null && isUp=1 || isUp=0;

  echo -ne ".";
  sleep $(( timeout++ ))
done

if [[ $isUp -eq 1 ]];
then
  echo "Up";
else
  echo "Timeout!";
  exit 1;
fi
