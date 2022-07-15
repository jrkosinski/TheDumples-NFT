// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title The Dumples NFT Collection 
 * @author John R. Kosinski 
 * 
 * The specs of this project are simple; the owner wants to be able to mint all tokens at once
 * or individually, with the option to (a) add more tokens in the future, and mint them, and 
 * (b) to create a new version of the contract if desired. 
 */
contract TheDumplesNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
    using Strings for uint256; 
    
    uint256 public maxSupply = 1; 
    string public baseUri = "ipfs://{hash}/";
    uint256 private _tokenIdCounter = 1;

    /**
     * Constructor. 
     * @param _name NFT token name 
     * @param _symbol NFT token symbol 
     * @param _maxSupply Number of items in the collection 
     * @param _baseUri Base URI used in token URI generation (incremented)
     */
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _maxSupply, 
        string memory _baseUri
        ) ERC721(_name, _symbol) {
            
        maxSupply = _maxSupply; 
        baseUri = _baseUri; 
    }

    /**
     * Pauses the contract execution. 
     * @dev Functions like transfer and mint will revert when contract is paused. 
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
    
    /**
     * Owner can change the maxSupply - the number of items in the collection. 
     * @param _maxSupply The new value to set for maxSupply. 
     */
    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }
    
    /**
     * Allows the owner to change the base token URI used to generate new token URIs. 
     * @param _baseUri The new value of baseUri. 
     */
    function setBaseUri(string memory _baseUri) public onlyOwner {
        baseUri = _baseUri; 
    }

    /**
     * Allows the owner to mint. 
     * @param _to The address of the token recipient once minted. 
     */
    function safeMint(address _to) public onlyOwner {
        require(this.totalSupply() < maxSupply, "TDN: Max supply exceeded"); 
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter+=1; 
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _concatUri(tokenId));
    }

    /**
     * Allows the owner to mint ALL tokens in the collection at once. 
     * @param _to The address of the token recipient once minted. 
     */
    function safeMintAll(address _to) public onlyOwner {
        for(uint n=0; n<maxSupply; n++) {
            safeMint(_to); 
        }
    }

    /**
     * Owner of a token may burn or destroy it. 
     * @param _tokenId The id of the token to burn. 
     */
    function burn(uint256 _tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ERC721Burnable: caller is not owner nor approved");
        
        //burn it 
        _burn(_tokenId);
    }

    /**
     * Returns the URI of the specified token. 
     * @param _tokenId The id of a token whose URI to return.
     * @return string Token URI. 
     */
    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }

    /**
     * ERC-165 implementation. 
     * @param _interfaceId An ERC-165 interface id to query. 
     * @return bool Whether or not the interface is supported by this contract. 
     */
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }
    
    
    /// NON-PUBLIC METHODS 

    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(_from, _to, _tokenId);
    }
    
    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(_tokenId);
    }
    
    function _concatUri(uint256 _tokenId) private view returns (string memory) {
        return string(abi.encodePacked(baseUri, _tokenId.toString(), ".json"));
    }
}
