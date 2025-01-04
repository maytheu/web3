// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721Connector.sol";

// contains all solidity code
contract KryptoBirdz is ERC721Connector {
    constructor() ERC721Connector("KryptoBirdz", "KBIRDZ") {}
}
