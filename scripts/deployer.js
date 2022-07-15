const utils = require("./lib/utils");

module.exports = {
    deploy: async () => {
        return await utils.deployContractSilent("DumplesNFT", [5, "ipfs://"]); 
    }
};

