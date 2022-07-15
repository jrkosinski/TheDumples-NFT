const { ethers, waffle} = require("hardhat");
const provider = waffle.provider;
const Runner = require("./lib/runner");

Runner.run(async (provider, owner) => {
    const contractAddr = "0x352603d9528184572a2b5B87c91d47E5c86dC7Fd";     
    
    //get engine address from storage slot 
    const nft = await ethers.getContractAt("DumplesNFT", contractAddr); 
    
    //await nft.setBaseUri("ipfs://QmTLrsTC3HaRWczSFuKfpTs5QUjDg8VC7GyxWjktVGA8Lc/"); 
    
    //console.log(await nft.maxSupply());
    //console.log(await nft.baseUri());
    
    await nft.safeMint(owner.address); 
    //console.log(await nft.balanceOf(owner.address));
    //console.log(await nft.tokenURI(1));
});