// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./interfaces/IItem.sol";
// import "./IRealm.sol";
// import "./IItemDefinition.sol";

contract Item is IItem {
  address _realm;
  address _definition;
  address _owner;

  constructor(address playerOwner, address itemDefinition) public {
    _realm = msg.sender;
    _definition = itemDefinition;
    _owner = playerOwner;
  }

  function Owner() public override view returns (address) {
    return _owner;
  }

  function Realm() public override view returns (address) {
    return _realm;
  }

  function Definition() public override view returns (address) {
    return _definition;
  }

  function TransferToRealm(address newRealm, address newDefinition) public override {
    require(msg.sender == _realm, "Only the realm may transfer ownership to another realm");

    _realm = newRealm;
    _definition = newDefinition;
  }

}
