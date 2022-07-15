const { expect } = require("chai");
const { ethers } = require("hardhat");
const utils = require("../scripts/lib/utils");

describe("TheDumplesNFT: Pausable", function () {		  
	let nft;				//contracts
	let owner, addr1; 		//accounts
    
    const BASE_URI = "ipfs://uri";
    const MAX_SUPPLY = 5; 
    const NAME = "TheDumplesTest"; 
    const SYMBOL = "TDT"; 
	
	beforeEach(async function () {
		[owner, addr1,...addrs] = await ethers.getSigners();
        
        //contract
		nft = await utils.deployContractSilent("TheDumplesNFT", [NAME, SYMBOL, MAX_SUPPLY, BASE_URI]); 
	});
	
	describe("Initial State", function () {
		it("is not paused", async function () {
			expect(await nft.paused()).to.equal(false); 
		});		
    });  
	
	describe("Pause can be called", function() {
		it("owner can pause", async function () {
            await nft.pause();
            expect(await nft.paused()).to.equal(true);
		});
        
		it("owner can unpause", async function () {
            await nft.pause();
            expect(await nft.paused()).to.equal(true);
            await nft.unpause();
            expect(await nft.paused()).to.equal(false);
		});
        
		it("cannot unpause when not paused", async function () {
            expect(await nft.paused()).to.equal(false);
            await expect(nft.unpause()).to.be.revertedWith("Pausable: not paused"); 
		});
        
		it("non-owner cannot pause", async function () {
            await expect(nft.connect(addr1).pause()).to.be.revertedWith("Ownable: caller is not the owner"); 
		});
	});
	
	describe("Behavior while Paused", function() {        
		it("cannot pause when paused", async function () {
            await nft.pause();
            expect(await nft.paused()).to.equal(true);
            await expect(nft.pause()).to.be.revertedWith("Pausable: paused"); 
		});
        
		it("cannot mint when paused", async function () {
            await nft.pause();
            expect(await nft.paused()).to.equal(true);
            await expect(nft.safeMint(addr1.address)).to.be.revertedWith("Pausable: paused"); 
		});
        
		it("cannot transfer when paused", async function () {
            await nft.safeMint(owner.address); 
            await nft.pause();
            expect(await nft.paused()).to.equal(true);
            await expect(nft.transferFrom(owner.address, addr1.address, 1)).to.be.revertedWith("Pausable: paused"); 
		});
	});
});