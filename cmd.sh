#!/bin/sh

set -e

if [ "$1" = "" ] || [ "$2" = "" ]; then
  echo "Usage: $0 <TV_IP> [-h | <COMMAND_NAME>]"
  exit 1
fi

IP=$1
CMDS=$(./print_ircc_codes.sh $IP)


if [ "$2" = "-h" ]; then
  NAMES=$(echo "$CMDS" | grep -o '"name": "[^"]*"' | sed 's/.*"\(.*\)"$/\1/')
  echo "$NAMES"
  exit 1
fi

CMD=$2
echo "LOOKING FOR CMD $CMD ON $IP"


CODE=$(echo "$CMDS" | grep -A1 "\"$CMD\"" | tail -n 1 | sed "s/.*\"\(.*\)\"$/\1/")

echo $CODE


if [ "$CODE" = "" ]; then
  echo "COULDN'T FIND COMMAND $CMD"
  exit 1
fi

./send_command.sh $IP $CODE
