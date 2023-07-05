// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Helper} from "./Helper.t.sol";
import {DeployAbstractNft} from "../script/DelpoyAbstractNft.s.sol";
import {AbstractNft} from "../src/AbstractNft.sol";

contract DeployAbstractNftTest is Test, Helper {
    DeployAbstractNft deployer;
    AbstractNft abstractNft;
    address user = makeAddr("user");

    function setUp() public {
        deployer = new DeployAbstractNft();
        abstractNft = deployer.run();
    }
}
