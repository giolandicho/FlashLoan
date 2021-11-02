// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "./IComptroller.sol";
import "./ICEther.sol";
import "./ICToken.sol";
import "./PriceFeed.sol";

contract Borrower {
    event myLog(string, uint256);

    address constant comptrollerAddress = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    address constant cETH_Address = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
    address constant cBAT_Address = 0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E;
    address constant cDAI_Address = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address constant cUSDC_Address = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;
    address constant cWBTC_Address = 0xC11b1268C1A384e55C48c2391d8d480264A3A7F4;
    address constant cZRX_Address = 0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407;
    address constant priceOracle = 0xDDc46a3B076aec7ab3Fc37420A8eDd2959764Ec4;


    function borrowFunds(
        address payable _cEtherAddress,
        address _comptrollerAddress,
        address _priceFeedAddress,
        address _cTokenAddress,
        uint _mintAmount) public payable returns (uint256) {
            ICEther icEth = ICEther(_cEtherAddress);
            IComptroller comptroller = IComptroller(_comptrollerAddress);
            PriceFeed priceFeed = PriceFeed(_priceFeedAddress);
            ICToken icToken = ICToken(_cTokenAddress);


            // supply ETH as collateral
            icEth.mint{value: _mintAmount}();

            // enter ETH market in order to borrow asset
            address [] memory icTokens = new address[](1);
            icTokens[0] = _cEtherAddress;
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
            uint256 underlyingPrice = priceFeed.getUnderlyingPrice(_cTokenAddress);
            uint256 maxBorrowUnderlying = liquidity / underlyingPrice;

            // Borrowing near the max amount will result
            // in your account being liquidated instantly
            emit myLog("Maximum underlying Borrow (borrow far less!)", maxBorrowUnderlying);



            // Borrow, check the underlying balance for this contract's address
            icToken.borrow(maxBorrowUnderlying * 3/4);

            // Get the borrow balance
            uint256 borrows = icToken.borrowBalanceCurrent(address(this));
            emit myLog("Current underlying borrow amount", borrows);

            return borrows;
        }
}