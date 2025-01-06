// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
    // an array to handle total supply
    uint256[] private _allTokens;
    // map tokenId to _alltoken index
    mapping(uint256 => uint256) private _allTokensIndex;
    // map owner address to list tokenID
    mapping(address => uint256[]) private _ownedToken;
    // map owner tokenid to index
    mapping(uint256 => uint256) private _ownedTokenIndex;

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256) {
        return _allTokens.length;
    }

   

    // function to inherit _mint() in ERC721
    // this overide the ERC721 def i.e virtual in ERC721
    function _mint(address to, uint tokenId) internal override(ERC721) {
        // run _mint in ERC721
        super._mint(to, tokenId);
        _addTokenToTotalSupply(tokenId);
    }

    function _addTokenToTotalSupply(uint256 tokenId) private {
        _allTokens.push(tokenId);
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokens.push(tokenId);
    }
}
