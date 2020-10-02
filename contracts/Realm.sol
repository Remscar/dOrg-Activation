// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Realm is Ownable {

  bytes32 public realmName;

  constructor(bytes32 name) Ownable() public {
    realmName = name;
  }

}
