#!/bin/bash

node_num=$1

if [[ -n "$node_num" ]]; then
  kill $(ps aux | grep "[n]ame $1" | awk '{print $2}')
else
  echo "USAGE: ./kill.sh [1|2|3|4|5]"
fi
