// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract REC721 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    // map token id to address owner
    mapping(uint => address) private _tokenOwner;
    // map address to owned tokens
    mapping(address => uint) private _ownedTokens;

    function _exist(uint tokenId) internal view returns (bool) {
        // check if tokenidi has an address
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal {
        // check if addres != 0
        require(to != address(0), "Must be ERC721 address", _);
        //    Check if token is associated to address
        require(!_exist(tokenId), "Token allready minted", _);

        // add token to address and increment count of address
        _tokenOwner[tokenId] = to;
        _ownedTokens[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}
