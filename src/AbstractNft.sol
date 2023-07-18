// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract AbstractNft is ERC721 {
    error AbstractNft__CantFlipStateIfNotOwner();
    error AbstractNft__NotEnoughTimeHasPassedToFlipState();
    error AbstractNft__CantFlipStateIfNftBurned();

    uint256 private s_tokenCounter;
    string private s_abstractSvgImageUri;
    string private s_crazyAbstractSvgImageUri;

    enum NftState {
        ABSTRACT,
        CRAZY,
        BURNED
    }

    mapping(uint256 => NftState) s_tokenIdToState;
    mapping(uint256 => uint256) s_tokenIdToTimestamp;

    constructor(
        string memory abstractSvgImageUri,
        string memory crazyAbstractSvgImageUri
    ) ERC721("Abstract NFT", "ABS") {
        s_tokenCounter = 0;
        s_abstractSvgImageUri = abstractSvgImageUri;
        s_crazyAbstractSvgImageUri = crazyAbstractSvgImageUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getAbstractSvgImageUri() public view returns (string memory) {
        return s_abstractSvgImageUri;
    }

    function getCrazyAbstractSvgImageUri() public view returns (string memory) {
        return s_crazyAbstractSvgImageUri;
    }

    function getTimestamp(uint256 tokenId) public view returns (uint256) {
        return s_tokenIdToTimestamp[tokenId];
    }

    function getState(uint256 tokenId) public view returns (NftState) {
        return s_tokenIdToState[tokenId];
    }

    function checkApproved(
        address addressToCheck,
        uint256 tokenId
    ) public view returns (bool) {
        return _isApprovedOrOwner(addressToCheck, tokenId);
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToState[s_tokenCounter] = NftState.ABSTRACT;
        s_tokenIdToTimestamp[s_tokenCounter] = block.timestamp;
        s_tokenCounter++;
    }

    //Only for testing purposes
    function mintNft(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
        s_tokenIdToState[s_tokenCounter] = NftState.ABSTRACT;
        s_tokenIdToTimestamp[s_tokenCounter] = block.timestamp;
        s_tokenCounter++;
    }

    function burnNft(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert AbstractNft__CantFlipStateIfNotOwner();
        }
        s_tokenIdToState[tokenId] = NftState.BURNED;
        s_tokenIdToTimestamp[tokenId] = 0;
        _burn(tokenId);
    }

    function delayConstant() public pure returns (uint256) {
        return 72000;
    }

    /**
     * @notice This function flips the NftState if the following validations have passed
     * 1. The msg.sender is approved to interact with the NFT
     * 1.1: A check for NftState of BURNED is not required as OZ isApprovedOrOwner reverts on burned token id
     * 2. Over 72000 blocks have passed since the mint
     * @param tokenId The tokenId of the NFT. This is set by the value of s_tokenCounter during mintNft()
     *
     */
    function flipState(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert AbstractNft__CantFlipStateIfNotOwner();
        }
        /* Redundant check see 1.1
            if (s_tokenIdToState[tokenId] == NftState.BURNED) {
            revert AbstractNft__CantFlipStateIfNftBurned();
            } 
        */
        if (
            block.timestamp < (s_tokenIdToTimestamp[tokenId] + delayConstant())
        ) {
            revert AbstractNft__NotEnoughTimeHasPassedToFlipState();
        }
        if (s_tokenIdToState[tokenId] == NftState.ABSTRACT) {
            s_tokenIdToState[tokenId] = NftState.CRAZY;
        } else {
            s_tokenIdToState[tokenId] = NftState.ABSTRACT;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageUri;
        if (s_tokenIdToState[tokenId] == NftState.ABSTRACT) {
            imageUri = s_abstractSvgImageUri;
        } else {
            imageUri = s_crazyAbstractSvgImageUri;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An abstract NFT that can turn crazy if the owner has held the nft for more than a 1000 days, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "craziness", "value": 0}], "image":"',
                                imageUri,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
