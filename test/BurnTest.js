const { expect } = require("chai");
const { ethers } = require("hardhat");
const utils = require("../scripts/lib/utils");

describe("TheDumplesNFT: Burning", function () {		  
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
});