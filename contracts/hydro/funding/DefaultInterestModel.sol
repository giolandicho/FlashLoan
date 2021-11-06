// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

/** for test purpose */
contract DefaultInterestModel {
    uint256 constant BASE = 10**18;

    /**
     * @param borrowRatio a decimal with 18 decimals
     */
    function polynomialInterestModel(uint256 borrowRatio) external pure returns(uint256) {
        // 0.2 * r + 0.5 * r**2

        // the valid range of borrowRatio is [0, 1]
        uint256 r = borrowRatio > BASE ? BASE : borrowRatio;
        return r / 5 + r * r / BASE / 2;
    }
}