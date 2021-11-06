// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

pragma experimental ABIEncoderV2;

import "./GlobalStore.sol";
import "./ExternalFunctions.sol";
import "./Operations.sol";

/**
 * Multi defi features in one contract
 *   1) Exchange (hybird mode, on-chain settlement, off-chain matching)
 *   2) Funding (lending and borrowing)
 *   3) Margin Trading
 */
contract Hydro is GlobalStore, ExternalFunctions, Operations {
    constructor(
        address _hotTokenAddress
    )
        public
    {
        state.exchange.hotTokenAddress = _hotTokenAddress;
        state.exchange.discountConfig = 0x043c000027106400004e205a000075305000009c404600000000000000000000;
    }
}