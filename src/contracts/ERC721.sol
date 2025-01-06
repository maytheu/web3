// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ERC721 {
    // map token id to address owner
    mapping(uint => address) private _tokenOwner;
    // map address to owned tokens
    mapping(address => uint) private _ownedTokens;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    // return total nfs owned/minted
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "Address do not exist");
        return _ownedTokens[_owner];
    }

    //return address based on mint index
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(_exist(_tokenId), "Token not found");
        return _tokenOwner[_tokenId];
        // address owner = _tokenOwner[_tokenId];
        // require(owner != address(0), "Nft index not found");
        // return owner;
    }

    function _exist(uint tokenId) internal view returns (bool) {
        // check if tokenidi has an address
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal virtual {
        // check if addres != 0
        require(to != address(0), "Must be ERC721 address");
        //    Check if token is associated to address
        require(!_exist(tokenId), "Token already minted");

        // add token to address and increment count of address
        _tokenOwner[tokenId] = to;
        _ownedTokens[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}
