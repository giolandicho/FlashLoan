// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

import "../interfaces/IPriceOracle.sol";
import "../lib/SafeMath.sol";

contract PriceOracleProxy {
    using SafeMath for uint256;

    address public asset;
    uint256 public decimal;
    address public sourceOracleAddress;
    address public sourceAssetAddress;
    uint256 public sourceAssetDecimal;

    constructor (
        address _asset,
        uint256 _decimal,
        address _sourceOracleAddress,
        address _sourceAssetAddress,
        uint256 _sourceAssetDecimal
    )
        public
    {
        asset = _asset;
        decimal = _decimal;
        sourceOracleAddress = _sourceOracleAddress;
        sourceAssetAddress = _sourceAssetAddress;
        sourceAssetDecimal = _sourceAssetDecimal;
    }

    function _getPrice()
        internal
        view
        returns (uint256)
    {
        uint256 price = IPriceOracle(sourceOracleAddress).getPrice(sourceAssetAddress);

        if (decimal >= sourceAssetDecimal) {
            price = price.div(10 ** (decimal - sourceAssetDecimal));
        } else {
            price = price.mul(10 ** (sourceAssetDecimal - decimal));
        }

        return price;
    }

    function getPrice(
        address _asset
    )
        external
        view
        returns (uint256)
    {
        require(_asset == asset, "ASSET_NOT_MATCH");
        return _getPrice();
    }

    function getCurrentPrice()
        external
        view
        returns (uint256)
    {
        return _getPrice();
    }
}