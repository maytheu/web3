// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721Connector.sol";

// contains all solidity code
contract KryptoBirdz is ERC721Connector {
    string[] public kryptobird;
    mapping(string => bool) _kryptobirdExist;

    function mint(string memory _kryptobird) public {
        require(!_kryptobirdExist[_kryptobird], "Kryptobirdz exist");

        kryptobird.push(_kryptobird);
        uint256 _id = kryptobird.length - 1;

        // _mint() from ERC721
        _mint(msg.sender, _id);
        _kryptobirdExist[_kryptobird] = true;
    }

    constructor() ERC721Connector("KryptoBirdz", "KBIRDZ") {}
}
