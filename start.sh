#!/bin/bash

node bin/naivecoin.js -p 3001 --name 1 > logs/node1.log &
sleep 2
node bin/naivecoin.js -p 3002 --name 2 --peers http://localhost:3001 > logs/node2.log &
sleep 2
node bin/naivecoin.js -p 3003 --name 3 --peers http://localhost:3001 http://localhost:3002 > logs/node3.log &
sleep 2
node bin/naivecoin.js -p 3004 --name 4 --peers http://localhost:3001 http://localhost:3002 http://localhost:3003 > logs/node4.log &
sleep 2
node bin/naivecoin.js -p 3005 --name 5 --peers http://localhost:3001 http://localhost:3002 http://localhost:3003 http://localhost:3004 > logs/node5.log &
sleep 2

# open http://localhost:3001/blockchain
# open http://localhost:3002/blockchain
# open http://localhost:3003/blockchain
# open http://localhost:3004/blockchain
# open http://localhost:3005/blockchain
# open http://localhost:3001/api-docs
# open http://localhost:3002/api-docs
# open http://localhost:3003/api-docs
# open http://localhost:3004/api-docs
# open http://localhost:3005/api-docs


