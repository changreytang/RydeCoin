# RydeCoin
Novel application of blockchain built on top of naivecoin

###Introduction
UCSB has a bustling ride-sharing community and students car-pool extensively every week. The commu-
nity exists as a Facebook group without any moderation. This leads to a lot of confusion as people posting
their vacancies have to constantly update their posts and make sure prospective car-poolers see the latest
'state' of their post.
Instead of a centralized system of exchange, we want to build a ride-sharing application on top of a
blockchain to create a trusted but decentralized system such that we dene a contract between the provider
and the consumer without any middle-man. By committing open rides to the blockchain, we ensure that
riders cannot back out last second without penalty and ensure that everyone follows the "smart contract"
on the blockchain.
This will be a permissioned system in which there will be two authenticated peer-to-peer entities that
receive money which gets held in RydeCoin until after a successsful exchange of sevices between the two
entities. The core idea lies in solving "double booking". We are ensuring this via two solutions. Firstly, every
seat will be given a unique id which will be hashed in the transaction detail. Secondly, as the blockchain is
public, "double-booking" can be checked for a particular seat in the car.
Another predicament in the current rideshare infrastructure is that people have no penalties for com-
mitting to a spot in a car and not showing up.1 On the other hand, someone can post a listing and ghost
the riders on the day of pickup. In the case of these disputes, we have a validation system that resolves the
situation by creating a pool of validators that vote on the authenticity of both parties. For the choice of
validators, we would like to explore the ideas aligning with rotating committee2
We also want to look into a unique blockchain model and incorporate some permission based elements
like a virtual structure on the network (ex: Chord, etc.) to investigate how the placement of nodes and
their reachability affects the over-all performance of our system in terms of commit latency and throughput.
Since this is a permissioned system, we can enforce a structure over the network such that each miner node
holds a "Finger table" which dictates which neighbor nodes to broadcast to. This data dissemination protocol
optimizes blockchain network performance and scalability by splitting workload across all nodes.

### How to use bash scripts
__start.sh__ spins up 3 nodes on ports 3001, 3002, and 3003

__stop.sh__ kills those 3 nodes

__clear-data.sh__ restarts the entire state of blockchain includings blocks, transactions, wallets, etc.

__kill.sh__ kills a specific node of the 3 you started with _start.sh_
- USAGE: ./kill.sh [1|2|3]

__restart.sh__ restarts a specific node you kill of the 3 you started with _start.sh_ (usually used right after kill.sh)
- USAGE: ./restart.sh [1|2|3]
