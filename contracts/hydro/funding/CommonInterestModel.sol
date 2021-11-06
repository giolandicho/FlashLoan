// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

contract CommonInterestModel {
    uint256 constant BASE = 10**18;

    /**
     * @param borrowRatio a decimal with 18 decimals
     */
    function polynomialInterestModel(uint256 borrowRatio) external pure returns(uint256) {
        // 0.55 * r**4 + 0.45 * r**8

        // the valid range of borrowRatio is [0, 1]
        uint256 r = borrowRatio > BASE ? BASE : borrowRatio;
        uint256 r2 = r * r / BASE;
        uint256 r4 = r2 * r2 / BASE;
        uint256 r8 = r4 * r4 / BASE;

        return (55 * r4 / 100) + (45 * r8 / 100);
    }
}