// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./openzeppelin/token/ERC721/ERC721.sol";
import "./openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "./openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import "./openzeppelin/security/Pausable.sol";
import "./openzeppelin/utils/Counters.sol";
import "./openzeppelin/utils/Strings.sol";
import "./openzeppelin/access/AccessControl.sol";
import "./IMintable.sol";

/**
 * @title The Dumples NFT Collection 
 * @author John R. Kosinski 
 * 
 * The specs of this project are simple; the owner wants to be able to mint all tokens at once
 * or individually, with the option to (a) add more tokens in the future, and mint them, and 
 * (b) to create a new version of the contract if desired. 
 */
contract TheDumplesNFT is 
        IMintable, 
        ERC721, 
        ERC721Enumerable, 
        ERC721URIStorage, 
        Pausable, 
        AccessControl {
    using Strings for uint256; 
    
    uint256 public maxSupply = 1; 
    uint256 public collectionSize = 1; 
    string public baseUri = "ipfs://{hash}/";
    uint256 private _tokenIdCounter = 0;
    
    bytes32 public constant MINTER_ROLE = "MINTER";

    /**
     * @dev Constructor. 
     * @param initialOwner Initial owner address (if 0x0, owner becomes msg.sender)
     * @param tokenName NFT token name 
     * @param tokenSymbol NFT token symbol 
     * @param _maxSupply Number of items in the collection 
     * @param _baseUri Base URI used in token URI generation (incremented)
     */
    constructor(
        address initialOwner,
        string memory tokenName, 
        string memory tokenSymbol, 
        uint256 _maxSupply, 
        uint256 _collectionSize, 
        string memory _baseUri
        ) ERC721(tokenName, tokenSymbol) {
        require(collectionSize <= maxSupply, "TDN: collectionSize may not exceed maxSupply"); 
            
        //if an address is passed, it is the owner 
        if (initialOwner == address(0)) {
            initialOwner = msg.sender;
        }
        
        //creator is admin and minter 
        _grantRole(MINTER_ROLE, initialOwner);
        _grantRole(DEFAULT_ADMIN_ROLE, initialOwner);
        
        //set state 
        maxSupply = _maxSupply; 
        collectionSize = _collectionSize;
        baseUri = _baseUri; 
    }

    /**
     * @dev Pauses the contract execution. Functions like transfer and mint will 
     * revert when contract is paused. 
     */
    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /**
     * @dev Unpauses the contract execution. 
     * Will revert if contract is not paused. 
     */
    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }
    
    /**
     * @dev Owner can change the maxSupply - the max number of items that can be minted. 
     * @param _maxSupply The new value to set for maxSupply. 
     */
    function setMaxSupply(uint256 _maxSupply) external onlyRole(DEFAULT_ADMIN_ROLE) {
        maxSupply = _maxSupply;
    }
    
    /**
     * @dev Owner can change the collectionSize - the number of items in the collection. 
     * @param _collectionSize The new value to set for maxSupply. 
     */
    function setCollectionSize(uint256 _collectionSize) external onlyRole(DEFAULT_ADMIN_ROLE) {
        collectionSize = _collectionSize;
    }
    
    /**
     * @dev Allows the owner to change the base token URI used to generate new token URIs. 
     * @param _baseUri The new value of baseUri. 
     */
    function setBaseUri(string memory _baseUri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        baseUri = _baseUri; 
    }

    /**
     * @dev Allows authorized caller (minter role only) to mint one. 
     * @param to The address of the token recipient once minted. 
     * @return The token ID of the minted token. 
     */
    function mintNext(address to) external override onlyRole(MINTER_ROLE) returns (uint256) {
        return _mintNext(to);
    }
    
    /**
     * @dev Mints the entire collection to the admin or owner (caller). 
     */
    function initialMint() external onlyRole(DEFAULT_ADMIN_ROLE) {
        for(uint n=0; n<collectionSize; n++) {
            _mintNext(msg.sender);
        }
    }
    
    /**
     * @dev Mints the specified number of items in the collection to the given address. 
     * If the address contains part of the collection already, starts from the last one 
     * minted to that address. 
     * The last index of the collection won't be exceeded. 
     * @return The number of tokens minted. 
     */
    function multiMint(address to, uint256 count) external override onlyRole(MINTER_ROLE) returns (uint256) {
        require(count <= collectionSize, "TDN: Count cannot exceed collection size"); 
        
        //get the start index & limit
        uint256 startIndex = this.balanceOf(to); 
        uint256 limit = startIndex + count; 
        if (limit > collectionSize) {
            limit = collectionSize;
        }
        
        //mint tokens and count number minted
        uint256 numberMinted = 0;
        for(uint n=startIndex; n<limit; n++) {
            _mintNext(to);
            numberMinted++;
        }
        
        return numberMinted;
    }

    /**
     * @dev Owner of a token may burn or destroy it. 
     * @param _tokenId The id of the token to burn. 
     */
    function burn(uint256 _tokenId) external virtual {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ERC721Burnable: caller is not owner nor approved");
        
        //burn it 
        _burn(_tokenId);
    }

    /**
     * @dev Returns the URI of the specified token. 
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
     * @dev ERC-165 implementation. 
     * @param _interfaceId An ERC-165 interface id to query. 
     * @return bool Whether or not the interface is supported by this contract. 
     */
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }
    
    
    /// NON-PUBLIC METHODS 

    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)  {
        super._beforeTokenTransfer(_from, _to, _tokenId);
    }
    
    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(_tokenId);
    }
    
    function _concatUri(uint256 _tokenId) private view returns (string memory) {
        return string(abi.encodePacked(baseUri, _tokenId.toString(), ".json"));
    }
    
    function _mintNext(address to) private returns (uint256) {
        require(this.totalSupply() < maxSupply, "TDN: Max supply exceeded"); 
        require(this.balanceOf(to) < collectionSize, "TDN: Max allowed per user exceeded"); 
            
        uint256 tokenId = ++_tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _concatUri(this.balanceOf(to)));
        return tokenId;
    }
}