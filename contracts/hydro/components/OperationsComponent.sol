// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

import "../lib/Requires.sol";
import "../lib/Events.sol";
import "../lib/Types.sol";

import "../funding/LendingPool.sol";
import "../funding/LendingPoolToken.sol";

import "../interfaces/IPriceOracle.sol";
import "../interfaces/ILendingPoolToken.sol";

/**
 * Independently deployment library of admin operations.
 */
library OperationsComponent {

    function createMarket(
        Store.State storage state,
        Types.Market memory market
    )
        public
    {
        Requires.requireMarketAssetsValid(state, market);
        Requires.requireMarketNotExist(state, market);
        Requires.requireDecimalLessOrEquanThanOne(market.auctionRatioStart);
        Requires.requireDecimalLessOrEquanThanOne(market.auctionRatioPerBlock);
        Requires.requireDecimalGreaterThanOne(market.liquidateRate);
        Requires.requireDecimalGreaterThanOne(market.withdrawRate);
        require(market.withdrawRate > market.liquidateRate, "WITHDARW_RATE_LESS_OR_EQUAL_THAN_LIQUIDATE_RATE");

        state.markets[state.marketsCount++] = market;
        Events.logCreateMarket(market);
    }

    function updateMarket(
        Store.State storage state,
        uint16 marketID,
        uint256 newAuctionRatioStart,
        uint256 newAuctionRatioPerBlock,
        uint256 newLiquidateRate,
        uint256 newWithdrawRate
    )
        external
    {
        Requires.requireMarketIDExist(state, marketID);
        Requires.requireDecimalLessOrEquanThanOne(newAuctionRatioStart);
        Requires.requireDecimalLessOrEquanThanOne(newAuctionRatioPerBlock);
        Requires.requireDecimalGreaterThanOne(newLiquidateRate);
        Requires.requireDecimalGreaterThanOne(newWithdrawRate);
        require(newWithdrawRate > newLiquidateRate, "WITHDARW_RATE_LESS_OR_EQUAL_THAN_LIQUIDATE_RATE");

        state.markets[marketID].auctionRatioStart = newAuctionRatioStart;
        state.markets[marketID].auctionRatioPerBlock = newAuctionRatioPerBlock;
        state.markets[marketID].liquidateRate = newLiquidateRate;
        state.markets[marketID].withdrawRate = newWithdrawRate;

        Events.logUpdateMarket(
            marketID,
            newAuctionRatioStart,
            newAuctionRatioPerBlock,
            newLiquidateRate,
            newWithdrawRate
        );
    }

    function setMarketBorrowUsability(
        Store.State storage state,
        uint16 marketID,
        bool   usability
    )
        external
    {
        Requires.requireMarketIDExist(state, marketID);
        state.markets[marketID].borrowEnable = usability;
        if (usability) {
            Events.logMarketBorrowDisable(
                marketID
            );
        } else {
            Events.logMarketBorrowEnable(
                marketID
            );
        }
    }

    function createAsset(
        Store.State storage state,
        address asset,
        address oracleAddress,
        address interestModelAddress,
        string calldata poolTokenName,
        string calldata poolTokenSymbol,
        uint8 poolTokenDecimals
    )
        external
    {
        Requires.requirePriceOracleAddressValid(oracleAddress);
        Requires.requireAssetNotExist(state, asset);

        LendingPool.initializeAssetLendingPool(state, asset);

        state.assets[asset].priceOracle = IPriceOracle(oracleAddress);
        state.assets[asset].interestModel = IInterestModel(interestModelAddress);
        state.assets[asset].lendingPoolToken = ILendingPoolToken(address(new LendingPoolToken(
            poolTokenName,
            poolTokenSymbol,
            poolTokenDecimals
        )));

        Events.logCreateAsset(
            asset,
            oracleAddress,
            address(state.assets[asset].lendingPoolToken),
            interestModelAddress
        );
    }

    function updateAsset(
        Store.State storage state,
        address asset,
        address oracleAddress,
        address interestModelAddress
    )
        external
    {
        Requires.requirePriceOracleAddressValid(oracleAddress);
        Requires.requireAssetExist(state, asset);

        state.assets[asset].priceOracle = IPriceOracle(oracleAddress);
        state.assets[asset].interestModel = IInterestModel(interestModelAddress);

        Events.logUpdateAsset(
            asset,
            oracleAddress,
            interestModelAddress
        );
    }

    /**
     * @param newConfig A data blob representing the new discount config. Details on format above.
     */
    function updateDiscountConfig(
        Store.State storage state,
        bytes32 newConfig
    )
        external
    {
        state.exchange.discountConfig = newConfig;
        Events.logUpdateDiscountConfig(newConfig);
    }

    function updateAuctionInitiatorRewardRatio(
        Store.State storage state,
        uint256 newInitiatorRewardRatio
    )
        external
    {
        Requires.requireDecimalLessOrEquanThanOne(newInitiatorRewardRatio);

        state.auction.initiatorRewardRatio = newInitiatorRewardRatio;
        Events.logUpdateAuctionInitiatorRewardRatio(newInitiatorRewardRatio);
    }

    function updateInsuranceRatio(
        Store.State storage state,
        uint256 newInsuranceRatio
    )
        external
    {
        Requires.requireDecimalLessOrEquanThanOne(newInsuranceRatio);

        state.pool.insuranceRatio = newInsuranceRatio;
        Events.logUpdateInsuranceRatio(newInsuranceRatio);
    }
}