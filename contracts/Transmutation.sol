// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./interfaces/ITransmutation.sol";
import "./interfaces/IItemDefinition.sol";

contract Transmutation is ITransmutation {

  bytes32 _name;
  address _originDefinition;
  address _targetDefinition;

  constructor(bytes32 transmutationName, address originItemDefinition, address itemDefinition) Ownable() public {
    _name = transmutationName;
    _originDefinition = originItemDefinition;
    _targetDefinition = itemDefinition;
  }

  function Name() public override view returns (bytes32) {
    return _name;
  }

  function Realm() public override view returns (address) {
    return owner();
  }

  function ItemDefinition() public override view returns (address) {
    return _targetDefinition;
  }

  function OriginRealm() public override view returns (address) {
    IItemDefinition originDefinition = IItemDefinition(_originDefinition);
    return originDefinition.Realm();
  }

  function OriginItemDefinition() public override view returns (address) {
    return _originDefinition;
  }

}
