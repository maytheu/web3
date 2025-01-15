// const { assert } = require("chai");


// const KryptoBirdz = artifacts.require("KryptoBirdz");

// require("chai")
//   .use(require("chai-as-promised"))
//   .should();

import chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { artifacts } from "truffle";

const { assert } = chai;
const KryptoBirdz = artifacts.require("KryptoBirdz");

chai.use(chaiAsPromised).should();

contract("KryptoBirdz", (accounts) => {
  let contract;

  before(async () => {
    contract = await KryptoBirdz.deployed();
  });

  describe("Deployment", () => {
    it("Should deployed successfully", async () => {
      const address = contract.address;

      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });

    it("Should name the contract KrytoBird", async () => {
      const name = await contract.name();

      assert.equal(name, "KryptoBirdz");
    });

    it("Should return a matching symbol", async () => {
      const symbol = await contract.symbol();

      assert.equal(symbol, "KBIRDZ");
    });
  });

  describe("minting", () => {
    it("Should create a new token", async () => {
      const result = await contract.mint("http://1");
      const totalSupply = await contract.totalSupply();

      const event = result.logs[0].args;

      assert.equal(totalSupply, 1);
      assert.equal(
        event._from,
        "0x0000000000000000000000000000000000000000",
        "from address"
      );
      assert.equal(event._to, accounts[0], "msg.sender");

      await contract.mint("http://1").should.be.rejected;
    });
  });

  describe("indexing", () => {
    it("Should list kryptobirdz", async () => {
      await contract.mint("http://2");
      await contract.mint("http://3");
      await contract.mint("http://4");
      await contract.mint("http://5");
      const totalSupply = await contract.totalSupply();

      const result = [];
      let kryptobirdz;
      for (let i = 1; i <= totalSupply; i++) {
        kryptobirdz = await contract.kryptobird(i - 1);
        result.push(kryptobirdz);
      }

      const expected = [
        "http://1",
        "http://2",
        "http://3",
        "http://4",
        "http://5",
      ];
      
      assert.equal(expected.join(","), result.join(","));
    });
  });
});
