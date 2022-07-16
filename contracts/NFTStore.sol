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
     * @param _nftContract The address of the NFT contract whose items are being sold. 
     * @param _mintPrice The price charged per unit to mint. 
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
    function mintNext(address to) external payable returns(uint256) {
        require(address(nftContract) != address(0), "NFTStore: NFT address not set");
        require(msg.value >= mintPrice, "NFTStore: transferred value less than price");
        
        return nftContract.mintNext(to); 
    }
    
    /**
     * @dev Sell multiple mints in the collection to a single user. Will be reverted if the 
     * number to be minted exceeds the number allowed.
     * @param to The NFT token recipient. 
     * @return The number minted and sold. 
     */
    function multiMint(address to, uint256 count) external payable returns (uint256) {
        require(address(nftContract) != address(0), "NFTStore: NFT address not set");
        
        uint256 numberMinted = nftContract.multiMint(to, count); 
        require(msg.value >= (numberMinted * mintPrice), "NFTStore: transferred value less than price");
        return numberMinted;
    }
    
    /**
     * @dev Contract owner can withdraw all collected funds from contract. 
     * @return True if successful. 
     */
    function withdrawAll() external onlyOwner returns (bool) {
        (bool success,) = msg.sender.call{value:address(this).balance}(""); 
        return success;
    }
}