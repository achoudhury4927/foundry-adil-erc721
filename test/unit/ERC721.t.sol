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
        assertEq("Abstract NFT", abstractNft.name());
    }

    function test_SymbolSetCorrectly() public {
        assertEq("ABS", abstractNft.symbol());
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
}
