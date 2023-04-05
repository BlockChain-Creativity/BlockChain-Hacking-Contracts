/* 
#Front Running
##Vulnerability
Transactions take some time before they are mined. An attacker can watch the transaction pool and send a transaction, have it included in a block before the original transaction. This mechanism can be abused to re-order transactions to the attacker's advantage.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
Alice creates a guessing game.
You win 10 ether if you can find the correct string that hashes to the target
hash. Let's see how this contract is vulnerable to front running.
*/

/*
1. Alice deploys FindThisHash with 10 Ether.
2. Bob finds the correct string that will hash to the target hash. ("Ethereum")
3. Bob calls solve("Ethereum") with gas price set to 15 gwei.
4. Eve is watching the transaction pool for the answer to be submitted.
5. Eve sees Bob's answer and calls solve("Ethereum") with a higher gas price
   than Bob (100 gwei).
6. Eve's transaction was mined before Bob's transaction.
   Eve won the reward of 10 ether.

What happened?
Transactions take some time before they are mined.
Transactions not yet mined are put in the transaction pool.
Transactions with higher gas price are typically mined first.
An attacker can get the answer from the transaction pool, send a transaction
with a higher gas price so that their transaction will be included in a block
before the original.
*/

contract FindThisHash {
    //  hi
    bytes32 public constant hash = 
        0x7624778dedc75f8b322b9fa1632a610d40b85e106c7d9bf0e743a9ce291b9c6f;

    constructor() payable {}

    function solve(string memory solution) public {
        require(hash == keccak256(abi.encodePacked(solution)),"Incorrect answer");

        (bool sent, ) = msg.sender.call{value: 10 ether}("");
        require(sent, "Failed to send Ether");
    }

    function gethash(string memory str) public pure returns(bytes32){
        return keccak256(abi.encodePacked(str));
    }
}