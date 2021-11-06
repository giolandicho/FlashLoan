// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

pragma experimental ABIEncoderV2;

import "./lib/Store.sol";

/**
 * Global state store
 */
contract GlobalStore {
    Store.State state;
}