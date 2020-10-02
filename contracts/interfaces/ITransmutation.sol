// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ITransmutation is Ownable {
  function Name() public virtual view returns (bytes32);
  function Realm() public virtual view returns (address);
  function ItemDefinition() public virtual view returns (address);
  function OriginRealm() public virtual view returns (address);
  function OriginItemDefinition() public virtual view returns (address);
}
