// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './SafeMath.sol';

library Counters{
    using SafeMath for uint256;

    struct Counter{
        uint256 _value;
    }

    function current(Counter storage counter) internal view returns(uint256){
        return counter._value;
    }

    function increment(Counter storage counter) internal{
        // ref safemath lib
        counter._value  = counter._value.add(1);
           }

    function decrement(Counter storage counter) internal{
        // ref safemath lib
        counter._value  = counter._value.subtract(1) ; 
          }

 
}