// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AbstractNft is ERC721 {
    uint256 private s_tokenCounter;
    string private rootSvg;

    constructor() ERC721("Abstract NFT", "ABS") {}
}
