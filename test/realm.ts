const Realm = artifacts.require("Realm");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Realm", function (/* accounts */) {

  it("Creates with expected name", async function () {
    const desiredName = "testRealm";
    const realmInstance = await Realm.new(web3.utils.asciiToHex(desiredName));
    return assert.equal(await realmInstance.Name(), desiredName);
  });




});
