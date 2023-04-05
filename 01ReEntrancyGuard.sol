/* 
## Preventative Techniques
 1. Ensure all state changes happen before calling external contracts
 2. Use function modifiers that prevent re-entrancy

Here is a example of a re-entracy guard
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ReEntrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}