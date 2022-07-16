module.exports = {
    BASE_URI : "ipfs://ipfs_file_hash/",
    MAX_SUPPLY : 5, 
    COLLECTION_SIZE : 5, 
    NAME : "TheDumplesTest", 
    SYMBOL : "TDT", 
    MINT_PRICE: 10000000000,
    
    roles: {
        ADMIN: ethers.utils.hexZeroPad(ethers.utils.hexlify(0), 32),
        MINTER: '0x4d494e5445520000000000000000000000000000000000000000000000000000'
    }
};