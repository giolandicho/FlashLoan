// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

interface PriceFeed {
    function getUnderlyingPrice(address cToken) external view returns (uint);
}