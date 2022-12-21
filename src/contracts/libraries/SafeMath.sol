//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {
    //build functions for safe math

    function add(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
        require(r >= x, 'safe math addition overflow');
        return r;
    }
    function sub(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y <= x, 'safe math subtraction overflow');
        uint256 r = x - y;
        return r;
    }
    function mul(uint256 x, uint256 y) internal pure returns(uint256) {
        // gass optimization
        if(x == 0) {
            return 0;
        }
        uint256 r = x * y;
        require(r / x == y, 'safe math multiply overflow');
        return r;
    }
    function devide(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y > 0, 'safe math devide overflow');
        uint256 r = x / y;
        
        return r;
    }
    //gas untouched
    function mod(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y != 0, 'safe math modulo by zero');
        return x % y;
    }
}