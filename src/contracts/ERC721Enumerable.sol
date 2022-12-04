//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    
    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex; //tokens at index in array
    mapping(address => uint256[]) private _ownedTokens; //list of owner tokens
    mapping(uint => uint) private _ownedTokensIndex;   //tokenId to index

        constructor() {
       _registerInterface(bytes4(keccak256('toalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^
          keccak256('tokenOfOwnerByIndex(bytes4)')));
        }
    function _mint(address to, uint256 tokenId) internal override(ERC721){
       super._mint(to, tokenId);
      _addTokensToAllTokenEnumeration(tokenId);
      _addTokensToOwnerEnueration(to, tokenId);
    }
     //add tokens to the _allTokens arrey and set the position in index
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnueration(address to, uint256 tokenId ) private {
         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
         _ownedTokens[to].push(tokenId);
         
    }

    function tokenByIndex(uint256 index ) public view override returns (uint256) {
        require (index < totalSupply(), "global index out of bounds"); 
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public view override returns(uint256) {
        require(index < balanceOf(owner),"owner index out of bounds");
        return _ownedTokens[owner] [index];
    }
     
//return the total supply of the _allTokens array
    function totalSupply() public view override returns(uint256) {
        return _allTokens.length;
    }
}
