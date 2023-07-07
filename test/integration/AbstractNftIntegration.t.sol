// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployAbstractNft} from "../../script/DelpoyAbstractNft.s.sol";
import {AbstractNft} from "../../src/AbstractNft.sol";

contract AbstractNftIntegrationTest is Test {
    DeployAbstractNft deployer;
    AbstractNft abstractNft;
    address user = makeAddr("user");

    string public ABSTRACT_IMAGE_URI_FROM_FILE =
        vm.readFile("./img/base64_image_uri_abstract.svg.txt");
    string public CRAZY_ABSTRACT_IMAGE_URI_FROM_FILE =
        vm.readFile("./img/base64_image_uri_crazyabstract.svg.txt");

    function setUp() public {
        deployer = new DeployAbstractNft();
        abstractNft = deployer.run();
    }

    function test_Constructor_TokenCounterSetCorrectly() public {
        assertEq(0, abstractNft.getTokenCounter());
    }

    function test_Constructor_AbstractSvgImageUriSetCorrectly() public {
        assertEq(
            keccak256(abi.encodePacked(ABSTRACT_IMAGE_URI_FROM_FILE)),
            keccak256(abi.encodePacked(abstractNft.getAbstractSvgImageUri()))
        );
    }

    function test_Constructor_CrazyAbstractSvgImageUriSetCorrectly() public {
        assertEq(
            keccak256(abi.encodePacked(CRAZY_ABSTRACT_IMAGE_URI_FROM_FILE)),
            keccak256(
                abi.encodePacked(abstractNft.getCrazyAbstractSvgImageUri())
            )
        );
    }

    function test_MintNft_CanMintToken() public {
        vm.prank(user);
        abstractNft.mintNft();
        assertEq(1, abstractNft.balanceOf(user));
        assertEq(user, abstractNft.ownerOf(0));
    }

    function test_MintNft_StateIsAbstractAfterMint() public {
        vm.prank(user);
        abstractNft.mintNft();
        assertEq(0, uint(abstractNft.getState(0)));
    }

    function test_MintNft_TimestampIsStoredAfterMint() public {
        skip(3600);
        vm.prank(user);
        abstractNft.mintNft();
        assertEq(3601, abstractNft.getTimestamp(0));
    }

    function test_MintNft_TokenCounterIncrementsAfterMint() public {
        vm.prank(user);
        abstractNft.mintNft();
        assertEq(1, abstractNft.getTokenCounter());
    }

    function test_DelayConstant_Returns72000() public {
        assertEq(72000, abstractNft.delayConstant());
    }
}
