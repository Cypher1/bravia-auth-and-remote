#!/bin/sh
set -e

function get_key() {
  echo "Press any key to continue" >> /dev/stderr
  while [ true ] ; do
  read -n 1 -r KEY
  if [ $? = 0 ] ; then
  break ;
  fi
  done
  echo $KEY
}

function get_code() {
  CMD=$1
  CODE=$(echo "$CMDS" | grep -A1 "\"$CMD\"" | tail -n 1 | sed "s/.*\"\(.*\)\"$/\1/")

  echo $CODE

  if [ "$CODE" = "" ]; then
    echo "COULDN'T FIND COMMAND $CMD" >> /dev/stderr
    exit 1
  fi
}

function cmd_for_key() {
  case $1 in
    "w" ) echo "Up" ;;
    "a" ) echo "Left" ;;
    "s" ) echo "Down" ;;
    "d" ) echo "Right" ;;
    "." ) echo "Confirm" ;;
    "i" ) echo "Input" ;;
    "m" ) echo "Mute" ;;
    "n" ) echo "Netflix" ;;
    "y" ) echo "Youtube" ;;
    "+" | "=" ) echo "VolumeUp" ;;
    "-" | "_" ) echo "VolumeDown" ;;
    "<" ) echo "ChannelUp" ;;
    ">" ) echo "ChannelDown" ;;
    "g" ) echo "GGuide" ;;
    esac
}

if [ "$1" = "" ]; then
  echo "Usage: $0 <TV_IP>" >> /dev/stderr
  exit 1
fi

IP=$1
CMDS=$(./print_ircc_codes.sh $IP)

while [ true ] ; do
  CMD=$(cmd_for_key $(get_key))
  CODE=$(get_code $CMD)
  ./send_command.sh $IP $CODE
done
