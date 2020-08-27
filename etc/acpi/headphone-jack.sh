#!/bin/bash
set -e -u

# Check your sinks:
# pacmd list-sinks | grep -e 'name:' -e 'index:'
defaultSinkName='hdmi-stereo';
headphoneSinkName='analog-stereo';

function pulseShell()
{
  user=$(getSessionUser);
  userDir=$(id -u "${user}");

  args="$@";
  echo $(PULSE_RUNTIME_PATH="/var/run/user/$userDir/pulse" su "$user" -c "${args[@]}");
}

function getSinkByName()
{
  user=$(getSessionUser);
  userDir=$(id -u "${user}");

  sinkDevices=$(PULSE_RUNTIME_PATH="/var/run/user/$userDir/pulse" su "$user" -c "pactl list short sinks");
  echo $(echo "$sinkDevices" | grep "$1");
}

function getSinkDevice()
{
  echo $(getSinkByName "$1" | tr -s '\t' ' ' | cut -d ' ' -f2);
}

function getSinkIdByName()
{
  echo $(getSinkByName "$1" | tr -s '\t' ' ' | cut -d ' ' -f1);
}

function switchActiveSinkStreams()
{
  outputSink="$1"

  for streamSink in $(echo $(pulseShell pactl list short sink-inputs) | tr -s '\t' ' ' | cut -d ' ' -f1);
  do
    notify-send "Moving Sink ${streamSink} > ${outputSink}";
    pulseShell pacmd move-sink-input ${streamSink} ${outputSink};
  done
}

function getSessionUser()
{
  userId=$(ls /var/run/user/ | head -n1);
  echo $(id -nu "$userId");
}

function notifySend()
{
  user=$(getSessionUser);

  args=$(printf "%s " "${@}");
  su "${user}" -c "XDG_RUNTIME_DIR=/run/user/${user} notify-send $args"
}

function switchAudioSink()
{
  if [ -z "$1" ];
  then
    return 1;
  fi

  user=$(getSessionUser);
  userDir=$(id -u "${user}");

  PULSE_RUNTIME_PATH="/var/run/user/$userDir/pulse" su "$user" -c "pacmd set-default-sink ${1}"

  return $?;
}

#args="$@";
#notifySend -i audio-speakers "'Debug: ${args[@]}'";

if [ "$1" = "jack/headphone" -a "$2" = "HEADPHONE" ];
then
    case "$3" in
        plug)
          sinkId=$(getSinkIdByName "${headphoneSinkName}");
          notifySend -i audio-headphones -t 1000 "'Switching audio device to ${headphoneSinkName}'";

          switchAudioSink "${sinkId}";
          switchActiveSinkStreams "${sinkId}";
        ;;

        unplug)
          sinkId=$(getSinkIdByName "${defaultSinkName}");
          notifySend -i audio-speakers -t 1000 "'Switching audio device to ${defaultSinkName}'";

          switchAudioSink "${sinkId}";
          switchActiveSinkStreams "${sinkId}";
        ;;
    esac
fi
