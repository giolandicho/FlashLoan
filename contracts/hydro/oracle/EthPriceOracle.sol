// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "../interfaces/IMakerDaoOracle.sol";
import "../lib/Ownable.sol";

/**
 * Eth USD price oracle for mainnet
 */
contract EthPriceOracle is Ownable {

    uint256 public sparePrice;
    uint256 public sparePriceBlockNumber;

    IMakerDaoOracle public constant makerDaoOracle = IMakerDaoOracle(0x729D19f657BD0614b4985Cf1D82531c67569197B);

    event PriceFeed(
        uint256 price,
        uint256 blockNumber
    );

    function getPrice(
        address _asset
    )
        external
        view
        returns (uint256)
    {
        require(_asset == 0x000000000000000000000000000000000000000E, "ASSET_NOT_MATCH");
        (bytes32 value, bool has) = makerDaoOracle.peek();
        if (has) {
            return uint256(value);
        } else {
            require(block.number - sparePriceBlockNumber <= 500, "ORACLE_OFFLINE");
            return sparePrice;
        }
    }

    function feed(
        uint256 newSparePrice,
        uint256 blockNumber
    )
        external
        onlyOwner
    {
        require(newSparePrice > 0, "PRICE_MUST_GREATER_THAN_0");
        require(blockNumber <= block.number && blockNumber >= sparePriceBlockNumber, "BLOCKNUMBER_WRONG");
        sparePrice = newSparePrice;
        sparePriceBlockNumber = blockNumber;

        emit PriceFeed(newSparePrice, blockNumber);
    }

}