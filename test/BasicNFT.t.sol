// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract BasicNFTTest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;
    address public user = makeAddr("user");
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function test_NameIsCorrect() public {
        string memory expectedName = "Dogie";
        string memory actualName = basicNFT.name();
        //assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)))
        assertEq(expectedName, actualName);
    }

    function test_CanMintAndHaveABalance() public {
        vm.prank(user);
        basicNFT.mintNft(PUG_URI);

        assert(basicNFT.balanceOf(user) == 1);
        assertEq(basicNFT.tokenURI(0), PUG_URI);
    }
}
