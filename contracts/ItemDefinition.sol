// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ItemDefinition is Ownable {

  bytes32 _name;

  constructor(bytes32 name) Ownable() public {
    _name = name;
  }

  function Name() public view returns (bytes32) {
    return _name;
  }

  function Realm() public view returns (address) {
    return owner();
  }

}
