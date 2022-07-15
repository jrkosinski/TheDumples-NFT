const { expect } = require("chai");
const { ethers } = require("hardhat");
const utils = require("../scripts/lib/utils");
const constants = require("./util/constants");

describe("TheDumplesNFT: Minting", function () {
    let nft;                    //contracts
    let owner, addr1, addr2;    //addresses
    
    //TODO: test multi-mint 
    
	beforeEach(async function () {
		[owner, addr1, addr2,...addrs] = await ethers.getSigners();
        
        //contract
		nft = await utils.deployContractSilent("TheDumplesNFT", [
            constants.NAME, 
            constants.SYMBOL, 
            constants.MAX_SUPPLY, 
            constants.BASE_URI
        ]); 
	});
    
    describe("Minting", function() {
        it("mint a token to owner", async function () {
            await nft.safeMint(owner.address); 
            
            expect(await nft.balanceOf(owner.address)).to.equal(1); 
            expect(await nft.balanceOf(addr1.address)).to.equal(0); 
            expect(await nft.ownerOf(1)).to.equal(owner.address); 
        }); 
        
        it("mint a token to non-owner", async function () {
            await nft.safeMint(addr1.address); 
            
            expect(await nft.balanceOf(addr1.address)).to.equal(1); 
            expect(await nft.balanceOf(owner.address)).to.equal(0); 
            expect(await nft.ownerOf(1)).to.equal(addr1.address); 
        }); 
        
        it("non-owner cannot mint token", async function () {
            await expect(nft.connect(addr1).safeMint(
                addr1.address)
            ).to.be.revertedWith("Ownable: caller is not the owner"); 
        }); 
        
        it("cannot get balance of nonexistent token", async function () {
            await expect(nft.ownerOf(1)).to.be.reverted;
        }); 
        
        it("can mint multiple tokens to same owner", async function () {
            await nft.safeMint(addr1.address); 
            await nft.safeMint(addr1.address); 
            
            expect(await nft.balanceOf(addr1.address)).to.equal(2); 
            expect(await nft.balanceOf(addr2.address)).to.equal(0); 
            expect(await nft.ownerOf(1)).to.equal(addr1.address); 
            expect(await nft.ownerOf(2)).to.equal(addr1.address); 
        }); 
        
        it("can mint multiple tokens to different owners", async function () {
            await nft.safeMint(addr1.address); 
            await nft.safeMint(addr2.address); 
            
            expect(await nft.balanceOf(addr1.address)).to.equal(1); 
            expect(await nft.balanceOf(addr2.address)).to.equal(1); 
            expect(await nft.ownerOf(1)).to.equal(addr1.address); 
            expect(await nft.ownerOf(2)).to.equal(addr2.address); 
        }); 
        
        it("mint all", async function () {
            await nft.safeMintAll(addr1.address); 
            
            expect(await nft.balanceOf(addr1.address)).to.equal(await nft.totalSupply()); 
        }); 
    }); 
    
    describe("Multiple Minting", function() {
    }); 
}); 