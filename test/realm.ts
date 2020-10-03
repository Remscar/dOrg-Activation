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

  


});
