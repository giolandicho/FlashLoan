// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

interface IInterestModel {
    function polynomialInterestModel(
        uint256 borrowRatio
    )
        external
        pure
        returns(uint256);
}