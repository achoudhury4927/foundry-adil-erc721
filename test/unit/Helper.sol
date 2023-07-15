// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Helper {
    uint256 nonsense;

    constructor(uint256 _nonsense) {
        nonsense = _nonsense;
    }

    fallback() external {
        revert();
    }
}
