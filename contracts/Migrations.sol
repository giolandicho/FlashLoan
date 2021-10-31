// SPDX-License-Identifier: GPL-3.0-or-later
// This file is part of Truffle suite and helps keep track of your deployments

pragma solidity >=0.4.21;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  constructor() {
    owner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
