#!/bin/bash

node bin/naivecoin.js -p 3001 --name 1 &
sleep 1
node bin/naivecoin.js -p 3002 --name 2 --peers http://localhost:3001 &
sleep 1
node bin/naivecoin.js -p 3003 --name 3 --peers http://localhost:3001 http://localhost:3002 &
sleep 1

open http://localhost:3001/blockchain
open http://localhost:3002/blockchain
open http://localhost:3003/blockchain
open http://localhost:3001/api-docs
open http://localhost:3002/api-docs
open http://localhost:3003/api-docs


