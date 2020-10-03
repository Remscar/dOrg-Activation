// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Item {
  address _realm;
  address _definition;
  address _player;

  constructor(address playerOwner, address itemDefinition) public {
    _realm = msg.sender;
    _definition = itemDefinition;
    _player = playerOwner;
  }

  function PlayerOwner() public view returns (address) {
    return _player;
  }

  function Realm() public view returns (address) {
    return _realm;
  }

  function Definition() public view returns (address) {
    return _definition;
  }

  function TransferToRealm(address newRealm, address newDefinition) public {
    require(msg.sender == _realm, "Only the Realm may transfer ownership to another realm");

    _realm = newRealm;
    _definition = newDefinition;
  }

}
