// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

interface ILendingPoolToken {
    function mint(
        address user,
        uint256 value
    )
        external;

    function burn(
        address user,
        uint256 value
    )
        external;

    function balanceOf(
        address user
    )
        external
        view
        returns (uint256);

    function totalSupply()
        external
        view
        returns (uint256);
}