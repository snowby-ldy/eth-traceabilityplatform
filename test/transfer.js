var Web3 = require("web3");

var contract = require("truffle-contract");
var data = require("../build/contracts/PRC.json");

var PRC = contract(data);

var provider = new Web3.providers.HttpProvider("http://localhost:8545");
PRC.setProvider(provider);

// console.info(WeiboRegistry.web3.eth.accounts)
var deployed;
PRC.deployed().then(function (instance) {
    var deployed = instance;
    return instance.sendTransaction({from: PRC.web3.eth.accounts[0], value: PRC.web3.toWei(1, 'ether')});
}).then(function (result) {
    // Do something with the result or continue with more transactions.
    console.info(result);
});
