const Deployer = require("./deployer");
const Runner = require("./lib/runner");

Runner.run(async () => {
    const nft = await Deployer.deployNFT();
    console.log(`NFT address is ${nft.address}`);
    
    const store = await Deployer.deployStore(nft.address); 
    console.log(`NFT store address is ${store.address}`);
});

