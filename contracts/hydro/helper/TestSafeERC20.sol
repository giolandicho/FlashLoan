// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "../lib/SafeERC20.sol";
import "./TestToken.sol";

/**
 * Test wrapper
 */
contract TestSafeERC20 {
    address public tokenAddress;

    constructor ()
        public
    {
        tokenAddress = address(new TestToken("test", "test", 18));
    }

    // transfer token out
    function transfer(
        address to,
        uint256 amount
    )
        public
    {
        SafeERC20.safeTransfer(tokenAddress, to, amount);
    }
}