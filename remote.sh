#!/bin/sh
set -e

function get_key() {
  while [ true ] ; do
    read -rsn 1 KEY
    if [ $? = 0 ] ; then
      break ;
    fi
  done
  echo $KEY
}

function get_code() {
  CMD=$1
  CODE=$(echo "$CMDS" | grep -A1 "\"$CMD\"" | tail -n 1 | sed "s/.*\"\(.*\)\"$/\1/")

  if [ "$CODE" = "" ]; then
    echo "COULDN'T FIND COMMAND $CMD" > /dev/stderr
    exit 1
  fi
  echo $CODE
}

function cmd_for_key() {
  case $1 in
    "0" | "1" | "2" | "3" | "4" | "5" | "7" | "8" | "9" )
      echo "Num$1" ;;
    "w" ) echo "Up" ;;
    "a" ) echo "Left" ;;
    "s" ) echo "Down" ;;
    "d" ) echo "Right" ;;
    "." ) echo "Confirm" ;;
    " " ) echo "Pause" ;;
    "\r" ) echo "Enter" ;;
    "i" ) echo "Input" ;;
    "m" ) echo "Mute" ;;
    "h" ) echo "Home" ;;
    "n" ) echo "Netflix" ;;
    "y" ) echo "YouTube" ;;
    "G" ) echo "GooglePlay" ;;
    "A" ) echo "ApplicationLauncher" ;;
    "t" ) echo "Tv" ;;
    "+" | "=" ) echo "VolumeUp" ;;
    "-" | "_" ) echo "VolumeDown" ;;
    "<" ) echo "ChannelUp" ;;
    ">" ) echo "ChannelDown" ;;
    "g" ) echo "GGuide" ;;
    "O" ) echo "TvPower" ;;
    esac
}

if [ "$1" = "" ]; then
  echo "Usage: $0 <TV_IP>" > /dev/stderr
  exit 1
fi

IP=$1
CMDS=$(./print_ircc_codes.sh $IP)

while [ true ] ; do
  CMD=$(cmd_for_key $(get_key))
  CODE=$(get_code $CMD)
  echo "Sending $CMD" > /dev/stderr
  ./send_command.sh $IP $CODE &
done
