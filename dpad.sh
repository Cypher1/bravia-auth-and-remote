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
}

if [ "$1" = "" ]; then
  echo "Usage: $0 <TV_IP>" >> /dev/stderr
  exit 1
fi

IP=$1
CMDS=$(./print_ircc_codes.sh $IP)

function get_code() {
  CMD=$1
  echo "LOOKING FOR CMD $CMD ON $IP" >> /dev/stderr


  CODE=$(echo "$CMDS" | grep -A1 "\"$CMD\"" | tail -n 1 | sed "s/.*\"\(.*\)\"$/\1/")

  echo $CODE

  if [ "$CODE" = "" ]; then
    echo "COULDN'T FIND COMMAND $CMD" >> /dev/stderr
    exit 1
  fi
}

function send_command() {
  echo "RUNNING $1" >> /dev/stderr
  ./send_command.sh $IP $1
}

LEFT=$(get_code "Left")
RIGHT=$(get_code "Right")
DOWN=$(get_code "Down")
UP=$(get_code "Up")
CONFIRM=$(get_code "Confirm")
INPUT=$(get_code "Input")

while [ true ] ; do
  get_key
  if [ "$KEY" = "w" ]; then
    send_command $UP
  fi
  if [ "$KEY" = "a" ]; then
    send_command $LEFT
  fi
  if [ "$KEY" = "s" ]; then
    send_command $DOWN
  fi
  if [ "$KEY" = "d" ]; then
    send_command $RIGHT
  fi
  if [ "$KEY" = "." ]; then
    send_command $CONFIRM
  fi
  if [ "$KEY" = "\t" ]; then
    send_command $INPUT
  fi
done
