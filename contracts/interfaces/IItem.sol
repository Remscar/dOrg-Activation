// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

// import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract IItem {
    function Owner() public virtual view returns (address);
    function Realm() public virtual view returns (address);
    function Definition() public virtual view returns (address);
    function TransferToRealm(address newRealm, address newDefinition) public virtual;
}
