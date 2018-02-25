#!/bin/bash

node_num=$1

if [[ -n "$node_num" ]]; then
  if [ $1 -eq 1 ]; then
    node bin/naivecoin.js -p 3001 --name 1 --peers http://localhost:3002 http://localhost:3003 &
  elif [ $1 -eq 2 ]
  then
    node bin/naivecoin.js -p 3002 --name 2 --peers http://localhost:3001 http://localhost:3003 &
  elif [ $1 -eq 3 ]
  then
    node bin/naivecoin.js -p 3003 --name 3 --peers http://localhost:3001 http://localhost:3002 &
  fi
else
  echo "USAGE: ./restart.sh [1|2|3|4|5]"
fi
