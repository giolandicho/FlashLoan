// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "../lib/SafeMath.sol";

/**
 * Test wrapper
 */
contract TestMath {
    function isRoundingError(
        uint256 a,
        uint256 b,
        uint256 c
    )
        public
        pure
        returns (bool)
    {
        return SafeMath.isRoundingError(a, b, c);
    }

    function getPartialAmountFloor(
        uint256 a,
        uint256 b,
        uint256 c
    )
        public
        pure
        returns (uint256)
    {
        return SafeMath.getPartialAmountFloor(a, b, c);
    }

    function min(
        uint256 a,
        uint256 b
    )
        public
        pure
        returns (uint256)
    {
        return SafeMath.min(a, b);
    }
}