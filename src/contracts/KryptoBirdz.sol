//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './ERC721Connector.sol';


contract KryptoBird is ERC721Connector{

    string[] public kryptoBirdz;
    mapping(string => bool) _kryptoBirdzexists;

    function mint(string memory _kryptoBird) public {
       require(!_kryptoBirdzexists[_kryptoBird], 'error - KryptoBird exists');

    //    uint _id = KryptoBirdz.push(_kryptoBird);   Depricated..
       kryptoBirdz.push(_kryptoBird);
       uint _id = kryptoBirdz.length - 1;
       _mint(msg.sender, _id);
       _kryptoBirdzexists[_kryptoBird] = true;
    }

 constructor() ERC721Connector("KryptoBird", "KBIRDZ") {
 }
}
