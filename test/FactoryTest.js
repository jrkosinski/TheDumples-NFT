const { expect } = require("chai");
const { ethers } = require("hardhat");
const utils = require("../scripts/lib/utils");
const constants = require("./util/constants");

describe("TheDumplesNFT: Factory", function () {		  
	let factory, nft;		//contracts
	let owner, addr1; 		//accounts
	
	beforeEach(async function () {
		[owner, addr1,...addrs] = await ethers.getSigners();
        
        //contract
		factory = await utils.deployContractSilent("TheDumplesNFTFactory"); 
	});
	
	describe("Spawn Contract", function () {
		it("new contract state", async function () {
            const nftAddr = await factory.spawn(
                constants.NAME, 
                constants.SYMBOL, 
                constants.MAX_SUPPLY, 
                constants.BASE_URI
            ); 
            
            //const nft = await ethers.getContractAt("TheDumplesNFT", nftAddr); 
			//expect(await nft.maxSupply()).to.equal(constants.MAX_SUPPLY); 
			//expect(await nft.baseUri()).to.equal(constants.BASE_URI); 
			//expect(await nft.name()).to.equal(constants.NAME); 
			//expect(await nft.symbol()).to.equal(constants.SYMBOL); 
		});
        
		it("non-owner cannot spawn", async function () {
            await expect(factory.connect(addr1).spawn(
                constants.NAME, 
                constants.SYMBOL, 
                constants.MAX_SUPPLY, 
                constants.BASE_URI
            )).to.be.revertedWith("Ownable: caller is not the owner"); 
		});
    });  
	
	describe("Factory Pausable", function () {
		it("non-owner cannot pause", async function () {
            await expect(factory.connect(addr1).pause()
            ).to.be.revertedWith("Ownable: caller is not the owner"); 
		});
        
		it("owner can pause", async function () {
            await factory.pause(); 
            expect(await factory.paused()).to.equal(true); 
        }); 
        
		it("owner can pause and unpause", async function () {
            await factory.pause(); 
            expect(await factory.paused()).to.equal(true); 
            await factory.unpause(); 
            expect(await factory.paused()).to.equal(false); 
        }); 
        
		it("cannot spawn when paused", async function () {
            await factory.pause(); 
            await expect(factory.spawn(
                constants.NAME, 
                constants.SYMBOL, 
                constants.MAX_SUPPLY, 
                constants.BASE_URI
            )).to.be.revertedWith("Pausable: paused"); 
		});
    });  
});