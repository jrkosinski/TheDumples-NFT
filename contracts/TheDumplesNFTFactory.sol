// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./openzeppelin/security/Pausable.sol";
import "./openzeppelin/access/Ownable.sol";
import "./TheDumplesNFT.sol";

/**
 * @title The Dumples NFT Collection Factory
 * @author John R. Kosinski 
 * 
 * Factory, spawns new contract. 
 * 
 * The specs of this project are simple; the owner wants to be able to mint all tokens at once
 * or individually, with the option to (a) add more tokens in the future, and mint them, and 
 * (b) to create a new version of the contract if desired. 
 */
contract TheDumplesNFTFactory is Ownable, Pausable {
    
    /**
     * Spawns a new DumplesNFT contract and returns the address. 
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
        string memory baseUri
    ) external onlyOwner whenNotPaused returns (address) {
        return address(new TheDumplesNFT(name, symbol, maxSupply, baseUri)); 
    } 

    /**
     * Pauses the contract execution. 
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * Unpauses the contract execution. 
     * @dev Will revert if contract is not paused. 
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}