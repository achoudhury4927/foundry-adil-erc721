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
    string public ABSTRACT_TOKEN_URI_FROM_FILE =
        vm.readFile("./img/base64_token_uri_abstract.svg.txt");
    string public CRAZY_ABSTRACT_TOKEN_URI_FROM_FILE =
        vm.readFile("./img/base64_token_uri_crazyabstract.svg.txt");

    function setUp() public {
        deployer = new DeployAbstractNft();
        abstractNft = deployer.run();
        vm.startPrank(user);
    }

    function test_Constructor_TokenCounterSetCorrectly() private {
        assertEq(0, abstractNft.getTokenCounter());
    }

    function test_Constructor_AbstractSvgImageUriSetCorrectly() private {
        assertEq(
            keccak256(abi.encodePacked(ABSTRACT_IMAGE_URI_FROM_FILE)),
            keccak256(abi.encodePacked(abstractNft.getAbstractSvgImageUri()))
        );
    }

    function test_Constructor_CrazyAbstractSvgImageUriSetCorrectly() private {
        assertEq(
            keccak256(abi.encodePacked(CRAZY_ABSTRACT_IMAGE_URI_FROM_FILE)),
            keccak256(
                abi.encodePacked(abstractNft.getCrazyAbstractSvgImageUri())
            )
        );
    }

    function test_MintNft_CanMintToken() private {
        abstractNft.mintNft();
        assertEq(1, abstractNft.balanceOf(user));
        assertEq(user, abstractNft.ownerOf(0));
    }

    function test_MintNft_StateIsAbstractAfterMint() private {
        abstractNft.mintNft();
        assertEq(0, uint(abstractNft.getState(0)));
    }

    function test_MintNft_BlockIsStoredAfterMint() private {
        skip(3600);
        abstractNft.mintNft();
        assertEq(3601, abstractNft.getBlock(0));
    }

    function test_MintNft_TokenCounterIncrementsAfterMint() private {
        abstractNft.mintNft();
        assertEq(1, abstractNft.getTokenCounter());
    }

    function test_DelayConstant_Returns72000() private {
        assertEq(72000, abstractNft.delayConstant());
    }

    function test_FlipState_RevertIf_NotOwner() private {
        abstractNft.mintNft();
        vm.prank(address(10));
        vm.expectRevert(
            AbstractNft.AbstractNft__CantFlipStateIfNotOwner.selector
        );
        abstractNft.flipState(0);
    }

    function test_FlipState_RevertIf_NotEnoughTimeHasPassedToFlipState()
        private
    {
        abstractNft.mintNft();
        vm.expectRevert(
            AbstractNft.AbstractNft__NotEnoughTimeHasPassedToFlipState.selector
        );
        abstractNft.flipState(0);
    }

    function test_FlipState_CanFlipState() private {
        abstractNft.mintNft();
        skip(72000);
        abstractNft.flipState(0);
        assertEq(0, uint(abstractNft.getState(1)));
    }

    function test_FlipState_CanFlipStateMultipleTimesAfterTimePasses() private {
        abstractNft.mintNft();
        skip(72000);
        abstractNft.flipState(0);
        assertEq(0, uint(abstractNft.getState(1)));
        abstractNft.flipState(0);
        assertEq(0, uint(abstractNft.getState(0)));
    }

    function test_TokenUri_ReturnsAbstracSvgTokenUri() private {
        abstractNft.mintNft();
        assertEq(
            keccak256(abi.encodePacked(ABSTRACT_TOKEN_URI_FROM_FILE)),
            keccak256(abi.encodePacked(abstractNft.getAbstractSvgImageUri()))
        );
    }

    function test_TokenUri_ReturnsCrazyAbstracSvgTokenUri() private {
        abstractNft.mintNft();
        skip(72000);
        abstractNft.flipState(0);
        assertEq(
            keccak256(abi.encodePacked(CRAZY_ABSTRACT_TOKEN_URI_FROM_FILE)),
            keccak256(abi.encodePacked(abstractNft.getAbstractSvgImageUri()))
        );
    }
}
