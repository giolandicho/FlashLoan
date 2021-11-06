// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.6;

/**
 * Some ERC20 Token contract doesn't return any value when calling the transfer function successfully.
 * So we consider the transfer call is successful in either case below.
 *   1. call successfully and nothing return.
 *   2. call successfully, return value is 32 bytes long and the value isn't equal to zero.
 */
library SafeERC20 {
    function safeTransfer(
        address token,
        address to,
        uint256 amount
    )
        internal
    {
        bool result;

        assembly {
            let tmp1 := mload(0)
            let tmp2 := mload(4)
            let tmp3 := mload(36)

            // keccak256('transfer(address,uint256)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
            mstore(0, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
            mstore(4, to)
            mstore(36, amount)

            // call ERC20 Token contract transfer function
            let callResult := call(gas(), token, 0, 0, 68, 0, 32)
            let returnValue := mload(0)

            mstore(0, tmp1)
            mstore(4, tmp2)
            mstore(36, tmp3)

            // result check
            result := and (
                eq(callResult, 1),
                or(eq(returndatasize(), 0), and(eq(returndatasize(), 32), gt(returnValue, 0)))
            )
        }

        if (!result) {
            revert("TOKEN_TRANSFER_ERROR");
        }
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    )
        internal
    {
        bool result;

        assembly {
            let tmp1 := mload(0)
            let tmp2 := mload(4)
            let tmp3 := mload(36)
            let tmp4 := mload(68)

            // keccak256('transferFrom(address,address,uint256)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
            mstore(0, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
            mstore(4, from)
            mstore(36, to)
            mstore(68, amount)

            // call ERC20 Token contract transferFrom function
            let callResult := call(gas(), token, 0, 0, 100, 0, 32)
            let returnValue := mload(0)

            mstore(0, tmp1)
            mstore(4, tmp2)
            mstore(36, tmp3)
            mstore(68, tmp4)

            // result check
            result := and (
                eq(callResult, 1),
                or(eq(returndatasize(), 0), and(eq(returndatasize(), 32), gt(returnValue, 0)))
            )
        }

        if (!result) {
            revert("TOKEN_TRANSFER_FROM_ERROR");
        }
    }
}