const { expect } = require("chai");
const { ethers } = require("hardhat");
const utils = require("../scripts/lib/utils");
const constants = require("./util/constants");

describe("TheDumplesNFT: Basic", function () {		  
	let nft;				//contracts
	let owner, addr1; 		//accounts
	
	beforeEach(async function () {
		[owner, addr1,...addrs] = await ethers.getSigners();
        
        //contract
		nft = await utils.deployContractSilent("TheDumplesNFT", [
            constants.NAME, 
            constants.SYMBOL, 
            constants.MAX_SUPPLY, 
            constants.BASE_URI
        ]); 
	});
	
	describe("Initial State", function () {
		it("property values", async function () {
			expect(await nft.maxSupply()).to.equal(constants.MAX_SUPPLY); 
			expect(await nft.baseUri()).to.equal(constants.BASE_URI); 
			expect(await nft.name()).to.equal(constants.NAME); 
			expect(await nft.symbol()).to.equal(constants.SYMBOL); 
		});
        
		it("balances", async function () {
			expect(await nft.totalSupply()).to.equal(0); 
			expect(await nft.balanceOf(owner.address)).to.equal(0); 
			expect(await nft.balanceOf(addr1.address)).to.equal(0); 
		});
    });  
	
	describe("Set/Read Properties", function () {
		it("max supply", async function () {
            const newSupply = 1111;
            await nft.setMaxSupply(newSupply);
			expect(await nft.maxSupply()).to.equal(newSupply); 
		});
        
		it("base URI", async function () {
            const newBaseUri = "NEW_BASE_URI";
            await nft.setBaseUri(newBaseUri);
			expect(await nft.baseUri()).to.equal(newBaseUri); 
		});
    });  
});