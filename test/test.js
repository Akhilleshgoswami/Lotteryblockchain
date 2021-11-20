const LotteryT = artifacts.require("./Lottery.sol");

contract("Lottery", (deployer) => {
  let Lottery;

  before(async () => {
    Lottery = await LotteryT.deployed();
  });

  describe("deployment", async () => {
    it("deploys successfully", async () => {
      const address = await Lottery.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    it("Tikect created", async () => {
      let TikectPrice = await Lottery.entryFee();
      TikectPrice = TikectPrice.toString();
      const event = await Lottery.takPart({
        from: "0x2cbCe1123C7371B19F2Bda8f5Bd3069Af523E164",
        value: TikectPrice,
      });
    console.log(event.logs[0].args)
    console.log(await Lottery.CreateAt())
    });

    //we can not test chainlink functionlity here becuase it only support Koven testnet,and online testnet and mainnet
  });
});
