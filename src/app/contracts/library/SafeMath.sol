// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library SafeMath {
    function add(uint256 a, uint216 b) internal pure returns (uint256) {
        uint256 r = a + b;
        require(r >= a, "SafeMath: Addition overflow");
        return r;
    }

    function subtract(uint256 a, uint216 b) internal pure returns (uint256) {
        uint256 r = a - b;
        require(a >= b, "SafeMath: Subtraction overflow");
        return r;
    }

    function multiply(uint256 a, uint216 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 r = a * b;
        require(r / a == b, "SafeMath: Multiply overflow");
        return r;
    }

    function divide(uint256 a, uint216 b) internal pure returns (uint256) {
        uint256 r = a / b;
        require(b > 0, "SafeMath: Divide overflow");
        return r;
    }

    function modulo(uint256 a, uint216 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: Modulo by 0");
        return a % b;
    }
}
