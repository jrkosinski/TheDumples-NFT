// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./openzeppelin/access/Ownable.sol";
import "./TheDumplesNFT.sol";
//import "./NFTStore.sol";

/**
 * @title The Dumples NFT Collection Factory
 * @author John R. Kosinski 
 * 
 * Factory, spawns new contract. This allows the true owner (customer) to launch the NFT contract
 * with his/her own account. 
 * 
 * The specs of this project are simple; the owner wants to be able to mint all tokens at once
 * or individually, with the option to (a) add more tokens in the future, and mint them, and 
 * (b) to create a new version of the contract if desired. 
 */
contract TheDumplesNFTFactory is Ownable {
    
    /**
     * @dev Spawns a new DumplesNFT contract and returns the address. 
     * @param name NFT token name 
     * @param symbol NFT token symbol 
     * @param maxSupply Number of items in the collection 
     * @param baseUri Base URI used in token URI generation (incremented)
     * @return The address of the new contract. 
     */
    function spawn(
        string memory name, 
        string memory symbol, 
        uint256 maxSupply, 
        string memory baseUri //, 
        //uint256 mintPrice
    ) external onlyOwner returns (address) {
        TheDumplesNFT nft = new TheDumplesNFT(name, symbol, maxSupply, baseUri); 
        //address storeAddr = address(new NFTStore(IMintable(nft), mintPrice));
        return (address(nft)); 
    } 
}