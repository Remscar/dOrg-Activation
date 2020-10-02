// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./interfaces/IRealm.sol";

contract Realm is IRealm {

  bytes32 _name;
  address[] _definitions;

  constructor(bytes32 name) Ownable() public {
    _name = name;
  }

  function Name() public override view returns (bytes32) {
    return _name;
  }

  function ItemDefinitions() public override view returns (address[] memory) {
    return _definitions;
  }

}
