// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "./helper/StandardToken.sol";

contract HydroToken is StandardToken {
    string public name = "Hydro Protocol Token";
    string public symbol = "HOT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1560000000 * 10**18;

    constructor() public {
        balances[msg.sender] = totalSupply;
    }
}