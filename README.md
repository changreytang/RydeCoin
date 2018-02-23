### RydeCoin
Novel application of blockchain built on top of naivecoin

##### How to use bash scripts
__start.sh__ spins up 3 nodes on ports 3001, 3002, and 3003
__stop.sh__ kills those 3 nodes
__clear-data.sh__ restarts the entire state of blockchain includings blocks, transactions, wallets, etc.
__kill.sh__ kills a specific node of the 3 you started with _start.sh_
- USAGE: ./kill.sh [1|2|3]
__restart.sh__ restarts a specific node you kill of the 3 you started with _start.sh_ (usually used right after kill.sh)
- USAGE: ./restart.sh [1|2|3]
