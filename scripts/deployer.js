const utils = require("./lib/utils");

module.exports = {
    deployNFT: async () => {
        return await utils.deployContractSilent("TheDumplesNFT", [
            "0x0000000000000000000000000000000000000000",
            "The Dumples NFT", 
            "TDN",
            100, 
            5,
            "ipfs://mtwirsqawjuoloq2gvtyug2tc3jbf5htm2zeo4rsknfiv3fdp46a/"
        ]); 
    }, 
    
    deployStore: async (nftAddr) => {
        return await utils.deployContractSilent("NFTStore", [
            nftAddr, 
            1000000000000000
        ]); 
    }
};

