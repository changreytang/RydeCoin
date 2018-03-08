const R = require('ramda');
const Wallets = require('./wallets');
const Wallet = require('./wallet');
const Transaction = require('../blockchain/transaction');
const TransactionBuilder = require('./transactionBuilder');
const Db = require('../util/db');
const ArgumentError = require('../util/argumentError');
const Config = require('../config');
const CryptoUtil = require('../util/cryptoUtil');
const Block = require('../blockchain/block');
const BlockAssertionError = require('../blockchain/blockAssertionError');

const OPERATOR_FILE = 'wallets.json';

class Operator {
    constructor(dbName, blockchain, name, miner) {
        this.db = new Db('data/' + dbName + '/' + OPERATOR_FILE, new Wallets());
        // INFO: In this implementation the database is a file and every time data is saved it rewrites the file, probably it should be a more robust database for performance reasons
        this.wallets = this.db.read(Wallets);
        this.blockchain = blockchain;
        this.miner = miner;
        // Create manager wallet/address if it doesn't exist yet
        let managerAddress = null;
        if (this.wallets.length == 0) {
            let managerPassword = this.createManagerPassword(name);
            let managerWallet = this.createWalletFromPassword(managerPassword);
            managerAddress  = this.generateAddressForWallet(managerWallet.id);
        }
        else
            managerAddress = this.getManagerAddress();

        //Start mining money now
        let seed = Math.floor((Math.random() * 20) + 1);
        let operator_freq = (30+seed+parseInt(name))*1000;
        this.mine_timer = setInterval(this.mineBlock.bind(this,managerAddress,managerAddress), operator_freq);

    }

    mineBlock(feeAddress,rewardAddress){
        this.miner.mine(feeAddress, rewardAddress)
        .then((newBlock) => {
            newBlock = Block.fromJson(newBlock);
            this.blockchain.addBlock(newBlock);
            console.log('Mined block successfully');
        })
        .catch((ex) => {
            if (ex instanceof BlockAssertionError && ex.message.includes('Invalid index')){
                console.log(ex);
            }
        });
    }

    createManagerPassword(name) {
        return `${name} ${name} ${name} ${name} ${name}`
    }

    addWallet(wallet) {
        this.wallets.push(wallet);
        this.db.write(this.wallets);
        return wallet;
    }

    createWalletFromPassword(password) {
        let newWallet = Wallet.fromPassword(password);
        return this.addWallet(newWallet);
    }

    checkWalletPassword(walletId, passwordHash) {
        let wallet = this.getWalletById(walletId);
        if (wallet == null) throw new ArgumentError(`Wallet not found with id '${walletId}'`);

        return wallet.passwordHash == passwordHash;
    }

    getWallets() {
        return this.wallets;
    }

    getManagerAddress() {
        let managerWallet = this.wallets[0];
        return managerWallet.getAddresses()[0];
    }

    getManagerWalletId() {
        return this.wallets[0].id;
    }

    getWalletById(walletId) {
        return R.find((wallet) => { return wallet.id == walletId; }, this.wallets);
    }

    generateAddressForWallet(walletId) {
        let wallet = this.getWalletById(walletId);
        if (wallet == null) throw new ArgumentError(`Wallet not found with id '${walletId}'`);

        let address = wallet.generateAddress();
        this.db.write(this.wallets);
        return address;
    }

    getAddressesForWallet(walletId) {
        let wallet = this.getWalletById(walletId);
        if (wallet == null) throw new ArgumentError(`Wallet not found with id '${walletId}'`);

        let addresses = wallet.getAddresses();
        return addresses;
    }

    getBalanceForAddress(addressId) {
        let utxo = this.blockchain.getUnspentTransactionsForAddress(addressId);

        if (utxo == null || utxo.length == 0) throw new ArgumentError(`No transactions found for address '${addressId}'`);
        return R.sum(R.map(R.prop('amount'), utxo));
    }

    createTransaction(walletId, fromAddressId, toAddressId, amount, changeAddressId) {
        let utxo = this.blockchain.getUnspentTransactionsForAddress(fromAddressId);
        let wallet = this.getWalletById(walletId);

        if (wallet == null) throw new ArgumentError(`Wallet not found with id '${walletId}'`);

        let secretKey = wallet.getSecretKeyByAddress(fromAddressId);

        if (secretKey == null) throw new ArgumentError(`Secret key not found with Wallet id '${walletId}' and address '${fromAddressId}'`);

        let tx = new TransactionBuilder();
        tx.from(utxo);
        tx.to(toAddressId, amount);
        tx.change(changeAddressId || fromAddressId);
        tx.fee(Config.FEE_PER_TRANSACTION);
        tx.sign(secretKey);

        return Transaction.fromJson(tx.build());
    }

    createTransaction_v1(walletId, fromAddressId, toAddressId, amount, changeAddressId, transactionMetaData, transactionType) {
        let utxo = this.blockchain.getUnspentTransactionsForAddress(fromAddressId);
        let wallet = this.getWalletById(walletId);

        if (wallet == null) throw new ArgumentError(`Wallet not found with id '${walletId}'`);

        let secretKey = wallet.getSecretKeyByAddress(fromAddressId);

        if (secretKey == null) throw new ArgumentError(`Secret key not found with Wallet id '${walletId}' and address '${fromAddressId}'`);

        //Create rideId only if ride post is created
        if (transactionType === 'create_ride'){
            //Get the rideId from a hash of meta data, wallet id and address of originator
            let rideId = CryptoUtil.hash({
                meta: transactionMetaData,
                wallet_id: walletId,
                address: fromAddressId
            });

            transactionMetaData.rideId = rideId;
        }
        
        let tx = new TransactionBuilder();
        tx.from(utxo);
        tx.to(toAddressId, amount);
        tx.change(changeAddressId || fromAddressId);
        if (transactionMetaData)
            tx.meta_data(transactionMetaData);
        tx.set_type(transactionType);
        tx.fee(Config.FEE_PER_TRANSACTION);
        tx.sign(secretKey);


        return Transaction.fromJson(tx.build());
    }
}

module.exports = Operator;
