// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

/**
 * Price Oracle for some stabilized assets
 */
abstract contract ConstPriceOracle {

    address asset;
    uint256 price;

    constructor(
        address _asset,
        uint256 _price
    )
        
    {
        asset = _asset;
        price = _price;
    }

    function getPrice(
        address _asset
    )
        external
        view
        returns (uint256)
    {
        require(asset == _asset, "ASSET_NOT_MATCH");
        return price;
    }
}