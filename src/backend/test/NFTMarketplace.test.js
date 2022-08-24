const { expect } = require("chai");

describe("NFTMarketplace", function () {
  let NFT;
  let nft;
  let deployer;
  let addr1;
  let addr2;
  let addrs;
  let URI = "sample URI";

  beforeEach(async function () {
    // Get the ContractFactories and Signers here.
    NFT = await ethers.getContractFactory("NFT");

    [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

    // To deploy our contracts
    nft = await NFT.deploy();
  });

  describe("Deployment", function () {
    it("Should track name and symbol of the nft collection", async function () {
      const nftName = "Ombre NFT";
      const nftSymbol = "Ombre";
      expect(await nft.name()).to.equal(nftName);
      expect(await nft.symbol()).to.equal(nftSymbol);
    });
  });

  describe("Minting NFTs", function () {
    it("Should track each minted NFT", async function () {
      // addr1 mints an nft
      await nft.connect(addr1).mint(URI);
      expect(await nft.tokenCount()).to.equal(1);
      expect(await nft.balanceOf(addr1.address)).to.equal(1);
      expect(await nft.tokenURI(0)).to.equal(URI);
      // addr2 mints an nft
      await nft.connect(addr2).mint(URI);
      expect(await nft.tokenCount()).to.equal(2);
      expect(await nft.balanceOf(addr2.address)).to.equal(1);
      expect(await nft.tokenURI(1)).to.equal(URI);
    });
  });

  describe("Transfer Tokens", function () {
    it("Should transfer token 0 from addr1 to addr2", async function () {
      // await nft.connect(addr1).mint(URI)

      await nft.connect(addr1).mint(URI);
      await nft.connect(addr1).transferToken(addr2.address, 0);
      expect(await nft.connect(addr2).isOwner(0)).to.equal(true);
      expect(await nft.balanceOf(addr2.address)).to.equal(1);
      expect(await nft.balanceOf(addr1.address)).to.equal(0);
    });
  });
});
