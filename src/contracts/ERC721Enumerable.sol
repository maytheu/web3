// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {
    // an array to handle total supply
    uint256[] private _allTokens;
    // map tokenId to _alltoken index
    mapping(uint256 => uint256) private _allTokensIndex;
    // map owner address to list tokenID
    mapping(address => uint256[]) private _ownedToken;
    // map owner tokenid to index
    mapping(uint256 => uint256) private _ownedTokenIndex;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply(bytes4)") ^
                    keccak256("tokenByIndex(bytes4)") ^
                    keccak256("tokenOfOwnerByIndex(bytes4)")
            )
        );
    }

    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(
        uint256 _index
    ) external view override returns (uint256) {
        require(_index <= totalSupply(), "Index greater than total supply");
        return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(
        address _owner,
        uint256 _index
    ) external view override returns (uint256) {
        require(
            _index <= balanceOf(_owner),
            "Index is greater than address balance"
        );
        require(_owner != address(0), "Invalid address");
        return _ownedToken[_owner][_index];
    }

    // function to inherit _mint() in ERC721
    // this overide the ERC721 def i.e virtual in ERC721
    function _mint(address to, uint tokenId) internal override(ERC721) {
        // run _mint in ERC721
        super._mint(to, tokenId);
        _addTokenToAllTokensEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokenIndex[tokenId] = _ownedToken[to].length;
        _ownedToken[to].push(tokenId);
    }
}
