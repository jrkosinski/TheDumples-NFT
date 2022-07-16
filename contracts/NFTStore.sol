// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IMintable.sol";
import "./openzeppelin/security/Pausable.sol";
import "./openzeppelin/access/Ownable.sol";

/**
 * @title The Dumples NFT Collection Factory
 * @author John R. Kosinski 
 * 
 * Minting/sale of NFT. 
 * 
 * The specs of this project are simple; the owner wants to be able to mint all tokens at once
 * or individually, with the option to (a) add more tokens in the future, and mint them, and 
 * (b) to create a new version of the contract if desired. 
 */
contract NFTStore is Pausable, Ownable {
    IMintable public nftContract; 
    uint256 public mintPrice = 0;
    
    /**
     * @dev Constructor. 
     */
    constructor(IMintable _nftContract, uint256 _mintPrice) {
        nftContract = _nftContract;
        mintPrice = _mintPrice;
    }
    
    /**
     * @dev Owner can set the price to mint an NFT. 
     * @param _mintPrice The price to set. 
     */
    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }
    
    /**
     * @dev Owner can pause execution. 
     */
    function pause() external onlyOwner {
        _pause(); 
    }
    
    /**
     * @dev Owner can unpause execution if paused. 
     */
    function unpause() external onlyOwner {
        _unpause(); 
    }
    
    /**
     * @dev Anyone can purchase the right to mint, and mint an NFT from contract. 
     * @param to The NFT token recipient. 
     * @return tokenId The ID of the minted token. 
     */
    function purchaseMint(address to) external payable returns(uint256 tokenId) {
        require(msg.value >= mintPrice, "NFTStore: transferred value less than price");
        require(address(nftContract) != address(0), "NFTStore: NFT address not set");
        
        nftContract.safeMint(to); 
        return 1;
    }
    
    /**
     * @dev Contract owner can withdraw all collected funds from contract. 
     */
    function withdrawAll() external onlyOwner returns (bool) {
        (bool success,) = msg.sender.call{value:address(this).balance}(""); 
        return success;
    }
}