const Deployer = require("./deployer");
const Runner = require("./lib/runner");

Runner.run(async () => {
    const nft = await Deployer.deploy();
    console.log(`NFT address is ${nft.address}`);
});

