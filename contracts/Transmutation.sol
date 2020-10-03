// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./ItemDefinition.sol";
import "./Item.sol";
import "./Realm.sol";

contract Transmutation is Ownable {

  bytes32 _name;
  address _originDefinition;
  address _targetDefinition;

  constructor(bytes32 transmutationName, address originItemDefinition, address itemDefinition) Ownable() public {
    _name = transmutationName;
    _originDefinition = originItemDefinition;
    _targetDefinition = itemDefinition;
  }

  function Name() public view returns (bytes32) {
    return _name;
  }

  function RealmOwner() public view returns (address) {
    return owner();
  }

  function TargetItemDefinition() public view returns (address) {
    return _targetDefinition;
  }

  function OriginRealm() public view returns (address) {
    ItemDefinition originDefinition = ItemDefinition(_originDefinition);
    return originDefinition.Realm();
  }

  function OriginItemDefinition() public view returns (address) {
    return _originDefinition;
  }

  function TransmuteItem(address item) public {
    Item targetItem = Item(item);
    Realm targetRealm = Realm(RealmOwner());
    Realm originRealm = Realm(OriginRealm());

    // Establish trust from sender
    require(msg.sender == OriginRealm(), "Initiator is not the realm.");

    // Establish trust of item
    require(msg.sender == targetItem.Realm(), "Item does not exist inside of it's own realm.");
    require(originRealm.ItemExists(item), "Item does not exist in origin realm.");

    // Ensure Item definition is correct
    require(targetItem.Definition() == OriginItemDefinition(), "Item is not of the right type.");

    // Validate we are valid (un-needed safety?)
    require(targetRealm.TransmutationExists(address(this)), "Transmutation is not valid.");

    // Tell the target realm to register the item
    targetRealm.RegisterItemFromTransmutation(item);
  }

}
