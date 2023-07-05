// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract AbstractNft is ERC721 {
    error AbstractNft_CantFlipStateIfNotOwner();
    error AbstractNft_NotEnoughTimeHasPassedToFlipState();

    uint256 private s_tokenCounter;
    string private s_abstractSvgImageUri;
    string private s_crazyAbstractSvgImageUri;

    enum NftState {
        ABSTRACT,
        CRAZY
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

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToState[s_tokenCounter] = NftState.ABSTRACT;
        s_tokenIdToTimestamp[s_tokenCounter] = block.timestamp;
        s_tokenCounter++;
    }

    function delayConstant() public pure returns (uint256) {
        return 72000;
    }

    function flipState(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert AbstractNft_CantFlipStateIfNotOwner();
        }
        if (
            block.timestamp < (s_tokenIdToTimestamp[tokenId] + delayConstant())
        ) {
            revert AbstractNft_NotEnoughTimeHasPassedToFlipState();
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
