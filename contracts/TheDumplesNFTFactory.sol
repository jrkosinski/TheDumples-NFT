// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
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
     * @param _name NFT token name 
     * @param _symbol NFT token symbol 
     * @param _maxSupply Number of items in the collection 
     * @param _baseUri Base URI used in token URI generation (incremented)
     * @return The address of the new contract. 
     */
    function spawn(
        string memory _name, 
        string memory _symbol, 
        uint256 _maxSupply, 
        string memory _baseUri
    ) public onlyOwner returns (address) {
        return address(new TheDumplesNFT(_name, _symbol, _maxSupply, _baseUri)); 
    } 

    /**
     * Pauses the contract execution. 
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * Unpauses the contract execution. 
     * @dev Will revert if contract is not paused. 
     */
    function unpause() public onlyOwner {
        _unpause();
    }
}
