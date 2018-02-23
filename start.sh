#!/bin/bash

node bin/naivecoin.js -p 3001 --name 1 &
node bin/naivecoin.js -p 3002 --name 2 --peers http://localhost:3001 &
node bin/naivecoin.js -p 3003 --name 3 --peers http://localhost:3001 http://localhost:3002 &


