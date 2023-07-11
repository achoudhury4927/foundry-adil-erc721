// SPDX-License-Identifier: MIT

/**
 * These tests are for my personal understanding
 * of the erc721 contract from Openzeppelin
 */
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AbstractNft} from "../../src/AbstractNft.sol";

contract ERC721Test is Test {
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
        abstractNft = new AbstractNft(
            ABSTRACT_IMAGE_URI_FROM_FILE,
            CRAZY_ABSTRACT_IMAGE_URI_FROM_FILE
        );
        vm.startPrank(user);
    }

    function test_NameSetCorrectly() public {
        assertEq("Abstract NFT", abstractNft.name(), "Has name Abstract NFT");
    }

    function test_SymbolSetCorrectly() public {
        assertEq("ABS", abstractNft.symbol(), "Has symbol ABS");
    }

    /**
     * EIP165 ID Grabbed from https://eips.ethereum.org/EIPS/eip-165
     */
    function test_SupportsInterfaceERC165() public {
        assertEq(true, abstractNft.supportsInterface(bytes4(0x01ffc9a7)));
    }

    /**
     * ERC721 ID Grabbed from https://stackoverflow.com/questions/69706835/how-to-check-if-the-token-on-opensea-is-erc721-or-erc1155-using-node-js
     */
    function test_SupportsInterfaceERC721() public {
        assertEq(true, abstractNft.supportsInterface(bytes4(0x80ac58cd)));
    }

    /**
     * ERC1155 ID Grabbed from https://stackoverflow.com/questions/69706835/how-to-check-if-the-token-on-opensea-is-erc721-or-erc1155-using-node-js
     */
    function test_DoesNotSupportInterfaceERC1155() public {
        assertEq(false, abstractNft.supportsInterface(bytes4(0xd9b67a26)));
    }

    function test_BalanceOf_RevertIf_ZeroAddress() public {
        vm.expectRevert("ERC721: address zero is not a valid owner");
        abstractNft.balanceOf(address(0));
    }

    function test_BalanceOf_ReturnsOne() public {
        abstractNft.mintNft();
        assertEq(abstractNft.balanceOf(user), 1);
    }

    function test_BalanceOf_ReturnsTwo() public {
        abstractNft.mintNft();
        abstractNft.mintNft();
        assertEq(abstractNft.balanceOf(user), 2);
    }

    function test_BalanceOf_ReturnsZero() public {
        assertEq(abstractNft.balanceOf(user), 0);
    }

    function test_OwnerOf_RevertIf_TokenIsBurnt() public {
        abstractNft.mintNft();
        abstractNft.burnNft(0);
        vm.expectRevert("ERC721: invalid token ID");
        abstractNft.ownerOf(0);
    }

    function test_OwnerOf_ReturnsOwner() public {
        abstractNft.mintNft();
        assertEq(user, abstractNft.ownerOf(0));
    }

    function test_Approve_RevertWhen_CurrentOwnerCallsApprove() public {
        abstractNft.mintNft();
        vm.expectRevert("ERC721: approval to current owner");
        abstractNft.approve(user, 0);
    }

    function test_Approve_RevertIf_NonOwnerOrUnapprovedCallsApprove() public {
        abstractNft.mintNft();
        vm.prank(address(10));
        vm.expectRevert(
            "ERC721: approve caller is not token owner or approved for all"
        );
        abstractNft.approve(address(9), 0);
    }

    function test_Approve_OwnerCanApprove() public {
        abstractNft.mintNft();
        abstractNft.approve(address(9), 0);
        assertEq(true, abstractNft.checkApproved(address(9), 0));
    }

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    function test_Approve_EmitsEventWhenApproved() public {
        abstractNft.mintNft();
        vm.expectEmit(true, true, true, true);
        emit Approval(user, address(9), 0);
        abstractNft.approve(address(9), 0);
    }

    function test_Approve_ApprovedForAllCanApprove() public {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(address(9), true);
        vm.prank(address(9));
        abstractNft.approve(address(10), 0);
        assertEq(true, abstractNft.checkApproved(address(10), 0));
    }

    function test_Approve_RevertIf_ApprovedCallsApprove() public {
        abstractNft.mintNft();
        abstractNft.approve(address(9), 0);
        vm.prank(address(9));
        vm.expectRevert(
            "ERC721: approve caller is not token owner or approved for all"
        );
        abstractNft.approve(address(10), 0);
    }
}
