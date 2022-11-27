//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract ERC721 {

    event Transfer(
        address indexed from, 
        address indexed to, 
        uint256 indexed  tokenId);
     
    mapping(uint256 => address ) private _tokenOwner;
    mapping(address => uint256) private _OwnedTokensCount;
    mapping(uint256 => address)  private _tokenAprovals;

    // @notice
    // @dev
    // @param _owner
    // @return

    function balanceOf(address _owner) public view returns(uint256) {
      require(_owner != address(0), 'token non exsits');
      return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non exsistant nft');
        return owner;
    }
    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }
  
    function _mint( address to, uint256 tokenId) internal virtual{
        require(to != address(0), "ERC721 : minting to zero address");
        require(!_exists(tokenId), "ERC721 token already exists");
          _tokenOwner[tokenId] = to;
          _OwnedTokensCount[to] += 1;

          emit Transfer(address(0), to, tokenId);
       }
    

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require (_to != address(0), 'ERC721 Transfer to zero address');
        require(ownerOf(_tokenId) == _from, "does not own address ");
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
        }

        function transferFrom(address _from, address _to, uint256 _tokenId)public {
           _transferFrom(_from, _to, _tokenId);
        }

   }
  