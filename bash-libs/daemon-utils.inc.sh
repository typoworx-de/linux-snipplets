function waitForTcpPort()
{
  declare -i tcpPort="$1";
  declare -i maxTimeout=4;
  declare -i timeout=0;
  declare -i isUp=0;

  until [[ "$isUp" -eq 1 || "${timeout}" -eq "${maxTimeout}" ]];
  do
    lsof -Pi TCP:${tcpPort} -t > /dev/null && isUp=1 || isUp=0;

    echo -ne "." >&2;
    sleep $(( timeout++ ))
  done

  echo $isUp;

  if [[ $isUp -eq 1 ]];
  then
    return 0;
  fi

  return 1;
}
