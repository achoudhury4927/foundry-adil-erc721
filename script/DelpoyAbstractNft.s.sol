// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {AbstractNft} from "../src/AbstractNft.sol";

contract DeployAbstractNft is Script {
    string public ABSTRACT_IMAGE_URI_FROM_FILE =
        vm.readFile("./img/base64_image_uri_abstract.svg.txt");
    string public CRAZY_ABSTRACT_IMAGE_URI_FROM_FILE =
        vm.readFile("./img/base64_image_uri_crazyabstract.svg.txt");

    function run() public returns (AbstractNft) {
        vm.startBroadcast();
        AbstractNft abstractNft = new AbstractNft(
            ABSTRACT_IMAGE_URI_FROM_FILE,
            CRAZY_ABSTRACT_IMAGE_URI_FROM_FILE
        );
        vm.stopBroadcast();
        return abstractNft;
    }
}
