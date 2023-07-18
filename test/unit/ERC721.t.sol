// SPDX-License-Identifier: MIT

/**
 * These tests are for my personal understanding
 * of the erc721 contract from Openzeppelin
 */
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AbstractNft} from "../../src/AbstractNft.sol";
import {Helper} from "./Helper.sol";
import {Helper2} from "./Helper2.sol";

contract ERC721Test is Test {
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    AbstractNft abstractNft;
    Helper helper;
    Helper2 helper2;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");
    address mallory = makeAddr("mallory");

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
        helper = new Helper(1);
        helper2 = new Helper2(1);
        vm.startPrank(alice);
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
        assertEq(
            true,
            abstractNft.supportsInterface(bytes4(0x01ffc9a7)),
            "Supports ERC165"
        );
    }

    /**
     * ERC721 ID Grabbed from https://stackoverflow.com/questions/69706835/how-to-check-if-the-token-on-opensea-is-erc721-or-erc1155-using-node-js
     */
    function test_SupportsInterfaceERC721() public {
        assertEq(
            true,
            abstractNft.supportsInterface(bytes4(0x80ac58cd)),
            "Supports ERC721"
        );
    }

    /**
     * ERC1155 ID Grabbed from https://stackoverflow.com/questions/69706835/how-to-check-if-the-token-on-opensea-is-erc721-or-erc1155-using-node-js
     */
    function test_DoesNotSupportInterfaceERC1155() public {
        assertEq(
            false,
            abstractNft.supportsInterface(bytes4(0xd9b67a26)),
            "Does not suppor ERC1155"
        );
    }

    function test_BalanceOf_RevertIf_ZeroAddress() public {
        vm.expectRevert("ERC721: address zero is not a valid owner");
        abstractNft.balanceOf(address(0));
    }

    function test_BalanceOf_ReturnsOne() public {
        abstractNft.mintNft();
        assertEq(abstractNft.balanceOf(alice), 1, "Balance of 1");
    }

    function test_BalanceOf_ReturnsTwo() public {
        abstractNft.mintNft();
        abstractNft.mintNft();
        assertEq(abstractNft.balanceOf(alice), 2, "Balance of 2");
    }

    function test_BalanceOf_ReturnsZero() public {
        assertEq(abstractNft.balanceOf(alice), 0, "Balance of 0");
    }

    function test_OwnerOf_RevertIf_TokenIsBurnt() public {
        abstractNft.mintNft();
        abstractNft.burnNft(0);
        vm.expectRevert("ERC721: invalid token ID");
        abstractNft.ownerOf(0);
    }

    function test_OwnerOf_ReturnsOwner() public {
        abstractNft.mintNft();
        assertEq(alice, abstractNft.ownerOf(0), "Returns Owner");
    }

    function test_Approve_RevertWhen_CurrentOwnerCallsApprove() public {
        abstractNft.mintNft();
        vm.expectRevert("ERC721: approval to current owner");
        abstractNft.approve(alice, 0);
    }

    function test_Approve_RevertIf_NonOwnerOrUnapprovedCallsApprove() public {
        abstractNft.mintNft();
        vm.prank(mallory);
        vm.expectRevert(
            "ERC721: approve caller is not token owner or approved for all"
        );
        abstractNft.approve(bob, 0);
    }

    function test_Approve_OwnerCanApprove() public {
        abstractNft.mintNft();
        abstractNft.approve(bob, 0);
        assertEq(
            true,
            abstractNft.checkApproved(bob, 0),
            "Bob approved by Alice"
        );
    }

    function test_Approve_EmitsEventWhenApproved() public {
        abstractNft.mintNft();
        vm.expectEmit(true, true, true, true);
        emit Approval(alice, bob, 0);
        abstractNft.approve(bob, 0);
    }

    function test_Approve_ApprovedForAllCanApprove() public {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(bob, true);
        vm.prank(bob);
        abstractNft.approve(charlie, 0);
        assertEq(
            true,
            abstractNft.checkApproved(charlie, 0),
            "Charlie approved by Bob on Alice NFT"
        );
    }

    function test_Approve_RevertIf_ApprovedNotApprovedForAllCallsApprove()
        public
    {
        abstractNft.mintNft();
        abstractNft.approve(mallory, 0);
        vm.prank(mallory);
        vm.expectRevert(
            "ERC721: approve caller is not token owner or approved for all"
        );
        abstractNft.approve(bob, 0);
    }

    function test_Approve_ApprovedCanBeChangedByOwner() public {
        abstractNft.mintNft();
        abstractNft.approve(bob, 0);
        assertEq(
            bob,
            abstractNft.getApproved(0),
            "Bob aproved by Alice to be changed"
        );
        abstractNft.approve(charlie, 0);
        assertEq(
            charlie,
            abstractNft.getApproved(0),
            "Charlie aproved by Alice, changed from bob"
        );
        assertEq(
            false,
            abstractNft.checkApproved(bob, 0),
            "Bob not approver anymore"
        );
    }

    function test_GetApproved_ReturnsApproved() public {
        abstractNft.mintNft();
        abstractNft.approve(bob, 0);
        assertEq(bob, abstractNft.getApproved(0), "getApproved returns bob");
    }

    function test_GetApproved_RevertIf_TokenHasNotBeenMinted() public {
        vm.expectRevert("ERC721: invalid token ID");
        abstractNft.getApproved(100);
    }

    function test_GetApproved_RevertIf_TokenIsBurned() public {
        abstractNft.mintNft();
        abstractNft.burnNft(0);
        vm.expectRevert("ERC721: invalid token ID");
        abstractNft.getApproved(0);
    }

    function test_SetApprovalForAll_RevertsIf_OwnerIsApprovingSelf() public {
        vm.expectRevert("ERC721: approve to caller");
        abstractNft.setApprovalForAll(alice, true);
    }

    function test_SetApprovalForAll_EmitsApprovalForAll() public {
        vm.expectEmit(true, true, true, true);
        emit ApprovalForAll(alice, bob, true);
        abstractNft.setApprovalForAll(bob, true);
    }

    function test_IsApprovedForAll_ReturnsTrueIfApprovedForAll() public {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(bob, true);
        assertEq(
            true,
            abstractNft.isApprovedForAll(alice, bob),
            "isApprovedForAll returns true for bob as set"
        );
    }

    function test_IsApprovedForAll_ReturnsFalseIfApprovedForAllSetFalse()
        public
    {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(bob, false);
        assertEq(
            false,
            abstractNft.isApprovedForAll(alice, bob),
            "isApprovedForAll returns false for bob as set"
        );
    }

    function test_IsApprovedForAll_ReturnsTrueWithMultipleApprovedForAll()
        public
    {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(bob, true);
        abstractNft.setApprovalForAll(charlie, true);
        assertEq(
            true,
            abstractNft.isApprovedForAll(alice, bob),
            "isApprovedForAll returns true for bob as set"
        );
        assertEq(
            true,
            abstractNft.isApprovedForAll(alice, charlie),
            "isApprovedForAll returns true for charlie as set"
        );
    }

    function test_TransferFrom_RevertsIf_NotApprovedOrOwner() public {
        abstractNft.mintNft();
        vm.expectRevert("ERC721: caller is not token owner or approved");
        vm.prank(mallory);
        abstractNft.transferFrom(alice, bob, 0);
    }

    function test_TransferFrom_RevertsIf_IncorrectTokenOwner() public {
        abstractNft.mintNft();
        abstractNft.setApprovalForAll(bob, true);
        vm.prank(bob);
        vm.expectRevert("ERC721: transfer from incorrect owner");
        abstractNft.transferFrom(bob, alice, 0);
    }

    function test_TransferFrom_RevertsIf_ToAddressIsZeroAddress() public {
        abstractNft.mintNft();
        vm.expectRevert("ERC721: transfer to the zero address");
        abstractNft.transferFrom(alice, address(0), 0);
    }

    function test_TransferFrom_TokenApprovalsAreDeletedAfterTransfer() public {
        abstractNft.mintNft();
        abstractNft.approve(bob, 0);
        abstractNft.transferFrom(alice, charlie, 0);
        assertNotEq(bob, abstractNft.getApproved(0));
    }

    function test_TransferFrom_BalancesAreUpdatedAfterTransfer() public {
        abstractNft.mintNft();
        assertEq(1, abstractNft.balanceOf(alice));
        assertEq(0, abstractNft.balanceOf(bob));
        abstractNft.transferFrom(alice, bob, 0);
        assertEq(0, abstractNft.balanceOf(alice));
        assertEq(1, abstractNft.balanceOf(bob));
    }

    function test_TransferFrom_OwnerIsUpdatedAfterTransfer() public {
        abstractNft.mintNft();
        assertEq(alice, abstractNft.ownerOf(0));
        abstractNft.transferFrom(alice, bob, 0);
        assertEq(bob, abstractNft.ownerOf(0));
    }

    function test_TransferFrom_EmitsTransferEvent() public {
        abstractNft.mintNft();
        vm.expectEmit(true, true, true, true);
        emit Transfer(alice, bob, 0);
        abstractNft.transferFrom(alice, bob, 0);
    }

    //Only testing safeTransferFrom _checkOnERC721Received call
    //as rest of the code is the same as transfer from

    /** 
     * Below is from Helper 2
     * function onERC721Received(
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
    */

    function test_SafeTransferFrom_RevertsIf_TransferToNonImplmenter() public {
        abstractNft.mintNft();
        vm.expectRevert("ERC721: transfer to non ERC721Receiver implementer");
        abstractNft.safeTransferFrom(alice, address(helper), 0);
    }

    function test_SafeTransferFrom_DoesNotRevertOnImplementer() public {
        abstractNft.mintNft();
        abstractNft.safeTransferFrom(alice, address(helper2), 0);
    }

    //Only testing _exists revert, mapping updates and emit for mint.
    //Already tested ERC721 receiver implementation from safeMint in the SafeTransferFrom tests
    function test_Mint_RevertIf_TokenAlreadyExists() public {
        abstractNft.mintNft();
        vm.expectRevert("ERC721: token already minted");
        abstractNft.mintNft(address(helper2), 0);
    }

    function test_Mint_UpdatesMappings() public {
        abstractNft.mintNft();
        assertEq(alice, abstractNft.ownerOf(0));
        assertEq(1, abstractNft.balanceOf(alice));
    }

    function test_Mint_EmitsTransferEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), alice, 0);
        abstractNft.mintNft();
    }

    //Only testing mapping updates and emit for burn
    function test_Burn_UpdatesMappings() public {
        abstractNft.mintNft();
        abstractNft.approve(bob, 0);
        assertEq(bob, abstractNft.getApproved(0));
        abstractNft.burnNft(0);
        //assertEq(address(0), abstractNft.getApproved(0)); returns invalid tokenId
        //assertEq(address(0), abstractNft.ownerOf(0)); returns invalid tokenId
        assertEq(0, abstractNft.balanceOf(alice));
    }

    function test_Burn_EmitsTransferEvent() public {
        abstractNft.mintNft();
        vm.expectEmit(true, true, true, true);
        emit Transfer(alice, address(0), 0);
        abstractNft.burnNft(0);
    }
}
