//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import  './libraries/Counters.sol';

contract ERC721 is ERC165, IERC721{
  using SafeMath for uint256;
  using Counters for Counters.Counter;

    mapping(uint256 => address ) private _tokenOwner;
    mapping(address => Counters.Counter) private _OwnedTokensCount;
    mapping(uint256 => address)  private _tokenApprovals;
    
    constructor() {
       _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^
          keccak256('transferFrom(bytes4)')));
    }

    function balanceOf(address _owner) public view override returns(uint256) {
      require(_owner != address(0), 'token non exsits');
      return _OwnedTokensCount[_owner].current();
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
      address owner = _tokenOwner[_tokenId];
      require(owner != address(0), 'owner query for non exsistant nft');
      return owner;
    }
    function _exists(uint256 tokenId) internal view returns(bool) {
      address owner = _tokenOwner[tokenId];
      return owner != address(0);
    }
  // not safe function..
    function _mint( address to, uint256 tokenId) internal virtual{
      require(to != address(0), "ERC721 : minting to zero address");
      require(!_exists(tokenId), "ERC721 token already exists");
        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to].increment();

          emit Transfer(address(0), to, tokenId);
       }
    
//not safe
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
      require (_to != address(0), 'ERC721 Transfer to zero address');
      require(ownerOf(_tokenId) == _from, "does not own address ");
        _OwnedTokensCount[_from].decrement;
        _OwnedTokensCount[_to].increment;
        _tokenOwner[_tokenId] = _to;
          emit Transfer(_from, _to, _tokenId);
        }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
      require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
        }

    function approve(address _to, uint tokenId) public {
      address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'current caller is nt token owner');
        _tokenApprovals[tokenId] = _to;
            emit Approval(owner, _to, tokenId);

        }
     
    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
          address owner = ownerOf(tokenId);
          return(spender == owner);
        
       }
        
   }
  