// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './ERC165.sol';

contract ERC721 is ERC165 {
    // map token id to address owner
    mapping(uint => address) private _tokenOwner;
    // map address to owned tokens
    mapping(address => uint) private _ownedTokens;
    mapping(uint256 => address) private _tokenApproval;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
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

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
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

        _ownedTokens[_from] += 1;
        _ownedTokens[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(_isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external {
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

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(_exist(_tokenId), "Token not found");
        return _tokenApproval[_tokenId];
    }
}
