// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

pragma experimental ABIEncoderV2;

import "./GlobalStore.sol";
import "./lib/Ownable.sol";
import "./lib/Types.sol";
import "./components/OperationsComponent.sol";

/**
 * Admin operations
 */
contract Operations is Ownable, GlobalStore {

    function createMarket(
        Types.Market memory market
    )
        public
        onlyOwner
    {
        OperationsComponent.createMarket(state, market);
    }

    function updateMarket(
        uint16 marketID,
        uint256 newAuctionRatioStart,
        uint256 newAuctionRatioPerBlock,
        uint256 newLiquidateRate,
        uint256 newWithdrawRate
    )
        external
        onlyOwner
    {
        OperationsComponent.updateMarket(
            state,
            marketID,
            newAuctionRatioStart,
            newAuctionRatioPerBlock,
            newLiquidateRate,
            newWithdrawRate
        );
    }

    function setMarketBorrowUsability(
        uint16 marketID,
        bool   usability
    )
        external
        onlyOwner
    {
        OperationsComponent.setMarketBorrowUsability(
            state,
            marketID,
            usability
        );
    }

    function createAsset(
        address asset,
        address oracleAddress,
        address interestModelAddress,
        string calldata poolTokenName,
        string calldata poolTokenSymbol,
        uint8 poolTokenDecimals
    )
        external
        onlyOwner
    {
        OperationsComponent.createAsset(
            state,
            asset,
            oracleAddress,
            interestModelAddress,
            poolTokenName,
            poolTokenSymbol,
            poolTokenDecimals
        );
    }

    function updateAsset(
        address asset,
        address oracleAddress,
        address interestModelAddress
    )
        external
        onlyOwner
    {
        OperationsComponent.updateAsset(
            state,
            asset,
            oracleAddress,
            interestModelAddress
        );
    }

    /**
     * @param newConfig A data blob representing the new discount config. Details on format above.
     */
    function updateDiscountConfig(
        bytes32 newConfig
    )
        external
        onlyOwner
    {
        OperationsComponent.updateDiscountConfig(
            state,
            newConfig
        );
    }

    function updateAuctionInitiatorRewardRatio(
        uint256 newInitiatorRewardRatio
    )
        external
        onlyOwner
    {
        OperationsComponent.updateAuctionInitiatorRewardRatio(
            state,
            newInitiatorRewardRatio
        );
    }

    function updateInsuranceRatio(
        uint256 newInsuranceRatio
    )
        external
        onlyOwner
    {
        OperationsComponent.updateInsuranceRatio(
            state,
            newInsuranceRatio
        );
    }
}