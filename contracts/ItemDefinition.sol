// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./interfaces/IItemDefinition.sol";

contract ItemDefinition is IItemDefinition {

  bytes32 _name;

  constructor(bytes32 name) Ownable() public {
    _name = name;
  }

  function Name() public override view returns (bytes32) {
    return _name;
  }

  function Realm() public override view returns (address) {
    return owner();
  }

}
