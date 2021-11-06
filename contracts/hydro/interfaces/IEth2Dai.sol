// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

interface IEth2Dai{
    function isClosed()
        external
        view
        returns (bool);

    function buyEnabled()
        external
        view
        returns (bool);

    function matchingEnabled()
        external
        view
        returns (bool);

    function getBuyAmount(
        address buy_gem,
        address pay_gem,
        uint256 pay_amt
    )
        external
        view
        returns (uint256);

    function getPayAmount(
        address pay_gem,
        address buy_gem,
        uint256 buy_amt
    )
        external
        view
        returns (uint256);
}