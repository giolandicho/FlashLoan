// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";
import "./compound/Borrower.sol";

contract Flashloan is FlashLoanReceiverBase, Borrower, Hydro {

    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //
        uint256 p1 = _amount / 5;
        uint256 p2 = _amount / 10;

        
        //Collateralise p1 and borrow ERC20
        borrowFunds(cETH_Address, comptrollerAddress, priceOracle, cWBTC_Address, p1);
        //Use p2 to short ETH with 5x margin against ERC20
        //Convert ERC20 back to ETH
        //Repay flash loan
        

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */
    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}
