// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract MintBasicNft is Script {
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployedBasicNFT = DevOpsTools
            .get_most_recent_deployment("BasicNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployedBasicNFT);
    }

    function mintNFTOnContract(address basicNFTAddress) public {
        vm.startBroadcast();
        BasicNFT(basicNFTAddress).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}
