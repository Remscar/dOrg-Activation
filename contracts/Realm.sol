// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./Item.sol";
import "./ItemDefinition.sol";
import "./Transmutation.sol";

contract Realm is Ownable {

  bytes32 _name;
  address[] _definitions;
  mapping (address => bool) _definitionExists;

  address[] _transmutations;
  mapping (address => bool) _transmutationExists;

  mapping (address => bool) _itemExists;

  constructor(bytes32 name) Ownable() public {
    _name = name;
  }

  function Name() public view returns (bytes32) {
    return _name;
  }

  function ItemDefinitions() public view returns (address[] memory) {
    return _definitions;
  }

  function Transmutations() public view returns (address[] memory) {
    return _transmutations;
  }

  function TransmutationExists(address transmutation) public view returns (bool) {
    return _transmutationExists[transmutation];
  }

  function ItemExists(address item) public view returns (bool) {
    return _itemExists[item];
  }

  event NewItemDefinition(ItemDefinition indexed definition);

  function CreateItemDefinition(bytes32 name) onlyOwner() public {
    ItemDefinition newItemDefinition = new ItemDefinition(name);
    _definitionExists[address(newItemDefinition)] = true;

    emit NewItemDefinition(newItemDefinition);
  }

  event NewTransmutation(Transmutation indexed transmutation);

  function CreateTransmutation(bytes32 name, address originItemDefinition, address targetItemDefinition) onlyOwner() public {
    require(_definitionExists[targetItemDefinition], "Target Item Definition doesn't exist in realm.");

    Transmutation newTransmutation = new Transmutation(name, originItemDefinition, targetItemDefinition);

    _transmutationExists[address(newTransmutation)] = true;
    _transmutations.push(address(newTransmutation));

    emit NewTransmutation(newTransmutation);
  }

  event NewItemCreated(Item indexed item);

  function CreateItem(address player, address itemDefinition) onlyOwner() public {
    Item newItem = new Item(player, itemDefinition);
    _itemExists[address(newItem)] = true;

    emit NewItemCreated(newItem);
  }

  function TransmuteItemForPlayer(address item, address transmutation) public {
    Item targetItem = Item(item);
    Transmutation targetTransmutation = Transmutation(transmutation);
    address playerOwner = targetItem.PlayerOwner();

    require(ItemExists(address(targetItem)), "Item must exist inside of realm");
    require(playerOwner == msg.sender, "Only the player owner of an item may initiate transmutation.");

    // Added security to prevent fake transmutation contracts
    Realm targetRealm = Realm(targetTransmutation.RealmOwner());
    require(targetRealm.TransmutationExists(transmutation), "Transmutation must belong to it's realm.");


    targetTransmutation.TransmuteItem(address(targetItem));
    targetItem.TransferToRealm(address(targetRealm), targetTransmutation.TargetItemDefinition());

    _itemExists[address(targetItem)] = false;
  }

  function RegisterItemFromTransmutation(address item) public {
    require(TransmutationExists(msg.sender), "Transmutation is not from this realm.");
    Item targetItem = Item(item);

    _itemExists[address(targetItem)] = true;
  }
  

}
