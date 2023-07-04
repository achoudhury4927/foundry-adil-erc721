// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Helper} from "./Helper.t.sol";
import {AbstractNft} from "../src/AbstractNft.sol";

contract AbstractNftTest is Test, Helper {
    AbstractNft abstractNft;
    address user = makeAddr("user");

    function setUp() public {
        abstractNft = new AbstractNft(
            Helper.ABSTRACT_IMAGE_URI,
            Helper.CRAZY_ABSTRACT_IMAGE_URI
        );
    }

    function test_ViewTokenUri() public {
        vm.prank(user);
        abstractNft.mintNft();
        console.log(abstractNft.tokenURI(0));
    }
}
