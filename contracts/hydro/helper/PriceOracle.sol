// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

import "../lib/Ownable.sol";

/**
 * A simple static oracle for test purpose.
 */
contract PriceOracle is Ownable {

    // token price to ether price
    mapping(address => uint256) public tokenPrices;

    // price decimals is 18
    function setPrice(
        address asset,
        uint256 price
    ) external onlyOwner {
        tokenPrices[asset] = price;
    }

    function getPrice(
        address asset
    )
        external
        view
        returns (uint256)
    {
        return tokenPrices[asset];
    }
}