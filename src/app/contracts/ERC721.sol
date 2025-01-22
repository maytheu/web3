// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import './library/Counters.sol';

contract ERC721 is ERC165, IERC721 {
    //unint to have access to SafeMath
    using SafeMath for uint256;
    // inherit counter struct
    using Counters for Counters.Counter;

    // map token id to address owner
    mapping(uint => address) private _tokenOwner;
    // map address to owned tokens
    mapping(address => Counters.Counter) private _ownedTokens;
    //Counters.Counter -> from counters libbrary
    mapping(uint256 => address) private _tokenApproval;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)") ^
                    keccak256("approve(bytes4)") ^
                    keccak256("getApproved(bytes4)")
            )
        );
    }

    // inherit from interfface
    // event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    // event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId );

    // return total nfts owned/minted
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "Address do not exist");
        return _ownedTokens[_owner].current();
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
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
        _ownedTokens[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_to != address(0), "Transfer to zero address");
        require(
            ownerOf(_tokenId) == _from,
            "Transfer token to invalid address"
        );

        _ownedTokens[_from].decrement();
        _ownedTokens[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(_isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override {
        address owner = ownerOf(_tokenId);
        require(_approved != owner, "Approval of current owner");
        require(msg.sender == owner, "You should be the onwer of this token");

        _tokenApproval[_tokenId] = _approved;

        emit Approval(owner, _approved, _tokenId);
    }

    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        require(_exist(tokenId), "Token not found");
        address owner = ownerOf(tokenId);
        require(spender != owner, "Approval of current owner");
        return spender == owner || getApproved(tokenId) == spender;
    }

    function getApproved(
        uint256 _tokenId
    ) public view override returns (address) {
        require(_exist(_tokenId), "Token not found");
        return _tokenApproval[_tokenId];
    }
}
