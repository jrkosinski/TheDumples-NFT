const { ethers } = require("hardhat");
const Deployer = require("./deployer");
const Runner = require("./lib/runner");

Runner.run(async (provider) => {
    
    const contractAddr = "0xa055A98e6ACbb3D011862B46de275cec7D9C8A8b";     
    
    const nft = await ethers.getContractAt("DumplesNFT", contractAddr); 
    
    await nft.setBaseUri(""); 
});
