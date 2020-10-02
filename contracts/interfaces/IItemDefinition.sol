// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract IItemDefinition is Ownable {
  function Name() public virtual view returns (bytes32);
  function Realm() public virtual view returns (address);
}
