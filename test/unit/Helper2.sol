// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Helper2 is IERC721Receiver {
    uint256 nonsense;

    constructor(uint256 _nonsense) {
        nonsense = _nonsense;
    }

    fallback() external {
        nonsense = 0;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
        //return bytes4("no") or no return value would make the below test fail
        //test_SafeTransferFrom_DoesNotRevertOnImplementer()

        //return bytes4("no") will trigger the assembly code
        //then the revert message will come from _safeTransfer

        //no return value will revert with the message before the assembley code
    }
}
