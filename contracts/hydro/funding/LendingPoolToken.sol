// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;
pragma experimental ABIEncoderV2;

import "../lib/Ownable.sol";
import "../helper/StandardToken.sol";

/**
 * A new kind of lending pool token will be created when a new asset is registered.
 * Normalized amounts of the asset in lending pool are stored in the corresponding
 * pool token contract as balance.
 */
contract LendingPoolToken is StandardToken, Ownable {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    event Mint(address indexed user, uint256 value);
    event Burn(address indexed user, uint256 value);

    constructor (
        string memory tokenName,
        string memory tokenSymbol,
        uint8 tokenDecimals
    )
        public
    {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
    }

    function mint(
        address user,
        uint256 value
    )
        external
        onlyOwner
    {
        balances[user] = balances[user].add(value);
        totalSupply = totalSupply.add(value);
        emit Mint(user, value);
    }

    function burn(
        address user,
        uint256 value
    )
        external
        onlyOwner
    {
        balances[user] = balances[user].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Burn(user, value);
    }

}