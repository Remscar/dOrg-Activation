const truffleAssert = require('truffle-assertions');

const Realm = artifacts.require("Realm");
const toHex = web3.utils.asciiToHex;
const toAscii = (i) => web3.utils.hexToAscii(i).replace(/\0/g, '');
const getEvent = (txResult, eventName) => {
  let res = undefined;
  truffleAssert.eventEmitted(txResult, eventName, (ev) => {
    res = ev;
    return true;
  });
  return res;
}

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Realm", function (accounts) {

  it("Creates with expected name", async function () {
    const desiredName = "testRealm";
    const realmInstance = await Realm.new(toHex(desiredName));
    return assert.equal(toAscii(await realmInstance.Name()), desiredName);
  });

  it("Can create item definitions", async function () {
    const realmANameHex = toHex("RealmA");
    const realmInstance = await Realm.new(realmANameHex);

    const itemDefName = "Apple";
    const result = await realmInstance.CreateItemDefinition(toHex(itemDefName));
    truffleAssert.eventEmitted(result, 'NewItemDefinition');
  });

  it("Can create items", async function () {
    const realmANameHex = toHex("RealmA");
    const realmInstance = await Realm.new(realmANameHex);

    const itemDefName = "Apple";
    const itemDefinition = getEvent(await realmInstance.CreateItemDefinition(toHex(itemDefName)), "NewItemDefinition").definition;

    const itemAddress = getEvent(await realmInstance.CreateItem(itemDefinition, accounts[1]), "NewItemCreated").item;
  });

  it("Can create transmutations", async function () {
    const realmANameHex = toHex("RealmA");
    const realmBNameHex = toHex("RealmA");

    const realmAInstance = await Realm.new(realmANameHex, { from: accounts[0] });
    const realmBInstance = await Realm.new(realmBNameHex, { from: accounts[1] });

    const appleItem = "Apple";
    const bananaItem = "Banana";

    const realmAItemDefinition = getEvent(await realmAInstance.CreateItemDefinition(toHex(appleItem), { from: accounts[0] }), "NewItemDefinition").definition;
    const realmBItemDefinition = getEvent(await realmBInstance.CreateItemDefinition(toHex(bananaItem), { from: accounts[1] }), "NewItemDefinition").definition;

    // Realm A has an apple
    // Realm B has a banana

    const transmutationName = "AppleFromAToBananaInB";

    truffleAssert.eventEmitted(
      await realmBInstance.CreateTransmutation(
        toHex(transmutationName),
        realmAItemDefinition,
        realmBItemDefinition,
        { from: accounts[1] }
        ),
      "NewTransmutation");
  });

  // Typically I write unit tests that only assert/test one thing, but for the sake of time, this test is more of an E2E test that will assert multiple things
  it("E2E: Can transmute an item from one realm to another", async function () {
    const realmANameHex = toHex("RealmA");
    const realmBNameHex = toHex("RealmA");

    const realmAInstance = await Realm.new(realmANameHex, { from: accounts[0] });
    const realmBInstance = await Realm.new(realmBNameHex, { from: accounts[1] });

    const appleItem = "Apple";
    const bananaItem = "Banana";

    const realmAItemDefinition = getEvent(await realmAInstance.CreateItemDefinition(toHex(appleItem), { from: accounts[0] }), "NewItemDefinition").definition;
    const realmBItemDefinition = getEvent(await realmBInstance.CreateItemDefinition(toHex(bananaItem), { from: accounts[1] }), "NewItemDefinition").definition;

    // Realm A has an apple
    // Realm B has a banana

    const transmutationName = "AppleFromAToBananaInB";

    const transmutation = getEvent(
      await realmBInstance.CreateTransmutation(
        toHex(transmutationName),
        realmAItemDefinition,
        realmBItemDefinition,
        { from: accounts[1] }
        ),
      "NewTransmutation").transmutation;
    
      // Give accounts[2] (player) an item in Realm A
      const playerItem = getEvent(await realmAInstance.CreateItem(accounts[2], realmAItemDefinition, { from: accounts[0] }), "NewItemCreated").item;

      // Player transmutes item from Realm A to Realm B
      await realmAInstance.TransmuteItemForPlayer(playerItem, transmutation, { from: accounts[2] });

      assert(!await realmAInstance.ItemExists(playerItem), "Item should no longer exist in Realm A");
      assert(await realmBInstance.ItemExists(playerItem), "Item should exist in Realm B");

      const Item = artifacts.require("Item");
      const itemInstance = await Item.at(playerItem);
      const itemDefinition = await itemInstance.Definition();

      assert.equal(itemDefinition, realmBItemDefinition, "Item should have definition that belongs to realm B");
  });

});
