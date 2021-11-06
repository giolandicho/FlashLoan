// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

/**
 * Consts used in multi files
 */
library Consts {
    function ETHEREUM_TOKEN_ADDRESS()
        internal
        pure
        returns (address)
    {
        return 0x000000000000000000000000000000000000000E;
    }

    // The base discounted rate is 100% of the current rate, or no discount.
    function DISCOUNT_RATE_BASE()
        internal
        pure
        returns (uint256)
    {
        return 100;
    }

    function REBATE_RATE_BASE()
        internal
        pure
        returns (uint256)
    {
        return 100;
    }
}