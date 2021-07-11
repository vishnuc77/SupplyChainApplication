const { assert } = require("console");

const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("should create new items", async() => {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 100;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, { from: accounts[0] });
        //assert.equal(result.logs[0].args._itemIndex, 0, "There should be only one item in the list");
        console.log(result);
        const item = await itemManagerInstance.items(0);
        //assert.equal(item._identifier, itemName, "The item has a different identifier");
        console.log(item);
    })
})