// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "./IComptroller.sol";
import "./ICEther.sol";
import "./ICToken.sol";
import "./PriceFeed.sol";

contract Borrower {
    event myLog(string, uint256);

    function borrowFunds(
        address payable _icEtherAddress,
        address _comptrollerAddress,
        address _priceFeedAddress,
        address _icTokenAddress,
        uint _underlyingDecimals) public payable returns (uint256) {
            ICEther icEth = ICEther(_icEtherAddress);
            IComptroller comptroller = IComptroller(_comptrollerAddress);
            PriceFeed priceFeed = PriceFeed(_priceFeedAddress);
            ICToken icToken = ICToken(_icTokenAddress);


            // supply ETH as collateral
            icEth.mint{value: msg.value}();

            // enter ETH market in order to borrow asset
            address [] memory icTokens = new address[](1);
            icTokens[0] = _icEtherAddress;
            uint256[] memory errors = comptroller.enterMarkets(icTokens);
            if (errors[0] != 0) {
                revert("Comptroller.enterMarkets failed");
            }
            // Get my account's total liquidity value in Compound
            (uint256 error, uint256 liquidity, uint256 shortfall) = comptroller
            .getAccountLiquidity(address(this));
            if (error != 0) {
                revert("Comptroller.getAccountLiquidity failed.");
            }
            require(shortfall == 0, "account underwater");
            require(liquidity > 0, "account has excess collateral");
            // Get the collateral factor for our collateral
            // (
            //   bool isListed,
            //   uint collateralFactorMantissa
            // ) = comptroller.markets(_cEthAddress);
            // emit MyLog('ETH Collateral Factor', collateralFactorMantissa);

            // Get the amount of underlying added to your borrow each block
            // uint borrowRateMantissa = cToken.borrowRatePerBlock();
            // emit MyLog('Current Borrow Rate', borrowRateMantissa);

            // Get the underlying price in USD from the Price Feed,
            // so we can find out the maximum amount of underlying we can borrow.
            uint256 underlyingPrice = priceFeed.getUnderlyingPrice(_icTokenAddress);
            uint256 maxBorrowUnderlying = liquidity / underlyingPrice;

            // Borrowing near the max amount will result
            // in your account being liquidated instantly
            emit myLog("Maximum underlying Borrow (borrow far less!)", maxBorrowUnderlying);

            // Borrow underlying
            uint256 numUnderlyingToBorrow = 10;

            // Borrow, check the underlying balance for this contract's address
            icToken.borrow(numUnderlyingToBorrow * 10**_underlyingDecimals);

            // Get the borrow balance
            uint256 borrows = icToken.borrowBalanceCurrent(address(this));
            emit myLog("Current underlying borrow amount", borrows);

            return borrows;
        }
}