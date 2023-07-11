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

    function test_MintNft_TimestampIsStoredAfterMint() private {
        skip(3600);
        abstractNft.mintNft();
        assertEq(3601, abstractNft.getTimestamp(0));
    }

    function test_MintNft_TokenCounterIncrementsAfterMint() private {
        abstractNft.mintNft();
        assertEq(1, abstractNft.getTokenCounter());
    }

    function test_BurnNft_CanBurnToken() private {
        abstractNft.mintNft();
        abstractNft.burnNft(0);
        assertEq(2, uint(abstractNft.getState(0)));
        assertEq(0, abstractNft.getTimestamp(0));
    }

    function test_BurnNft_OnlyApprovedOrOwnerCanBurn() private {
        abstractNft.mintNft();
        vm.startPrank(address(10));
        vm.expectRevert(
            AbstractNft.AbstractNft__CantFlipStateIfNotOwner.selector
        );
        abstractNft.burnNft(0);
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

    function test_FlipState_RevertIf_NftStateIsBurned() private {
        abstractNft.mintNft();
        abstractNft.burnNft(0);
        vm.expectRevert("ERC721: invalid token ID");
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
            keccak256(abi.encodePacked(abstractNft.tokenURI(0)))
        );
    }

    function test_TokenUri_ReturnsCrazyAbstracSvgTokenUri() private {
        abstractNft.mintNft();
        skip(72000);
        abstractNft.flipState(0);
        assertEq(
            keccak256(abi.encodePacked(CRAZY_ABSTRACT_TOKEN_URI_FROM_FILE)),
            keccak256(abi.encodePacked(abstractNft.tokenURI(0)))
        );
    }

    function test_CheckApproved_TrueWhenOwner() public {
        abstractNft.mintNft();
        assertEq(true, abstractNft.checkApproved(user, 0));
    }

    function test_CheckApproved_TrueWhenApproved() public {
        abstractNft.mintNft();
        abstractNft.approve(address(9), 0);
        assertEq(true, abstractNft.checkApproved(address(9), 0));
    }

    function test_CheckApproved_TrueWhenApprovedForAll() public {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(address(9), true);
        assertEq(true, abstractNft.checkApproved(address(9), 0));
    }

    function test_CheckApproved_FalseWhenNonOwnerAndNotAproved() public {
        abstractNft.mintNft();
        assertEq(false, abstractNft.checkApproved(address(9), 0));
    }
}
