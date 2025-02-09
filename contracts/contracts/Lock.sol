// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MEMEAX is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;
    uint256[] private _allMintedNFTs;
    
    struct NFTMetadata {
        string title;
        string description;
        string metadataURI;
        address creator;
    }
    
    struct Listing {
        address seller;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => NFTMetadata) private _nftDetails;
    mapping(uint256 => Listing) private _listings;
    mapping(address => uint256[]) private _ownerNFTs;
    
    event NFTMinted(address indexed owner, uint256 indexed tokenId, string metadataURI);
    event NFTListed(address indexed seller, uint256 indexed tokenId, uint256 price);
    event NFTSold(address indexed buyer, address indexed seller, uint256 indexed tokenId, uint256 price);
    
    constructor() ERC721("MemeaxNFT", "MEMEAX") Ownable(msg.sender) {}
    
    function mintMemeNFT(
        address recipient,
        string memory title,
        string memory description,
        string memory metadataURI
    ) public returns (uint256) {
        _tokenIds += 1;
        uint256 newItemId = _tokenIds;

        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, metadataURI);
        
        _nftDetails[newItemId] = NFTMetadata({
            title: title,
            description: description,
            metadataURI: metadataURI,
            creator: msg.sender
        });

        _allMintedNFTs.push(newItemId);
        _ownerNFTs[recipient].push(newItemId);
        
        emit NFTMinted(recipient, newItemId, metadataURI);
        return newItemId;
    }

    function getAllNFTs() public view returns (uint256[] memory) {
        return _allMintedNFTs;
    }
    
    function getNFTDetails(uint256 tokenId) public view returns (string memory, string memory, string memory, address) {
        NFTMetadata memory metadata = _nftDetails[tokenId];
        return (metadata.title, metadata.description, metadata.metadataURI, metadata.creator);
    }
    
    function getNFTsByOwner(address owner) public view returns (uint256[] memory) {
        return _ownerNFTs[owner];
    }
    
    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");
        
        _listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            isListed: true
        });
        
        emit NFTListed(msg.sender, tokenId, price);
    }
    
    function buyNFT(uint256 tokenId) public payable {
        Listing memory listing = _listings[tokenId];
        require(listing.isListed, "NFT not for sale");
        require(msg.value >= listing.price, "Insufficient funds");
        
        address seller = listing.seller;
        require(seller != msg.sender, "Cannot buy your own NFT");
        
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);
        
        _listings[tokenId].isListed = false;
        
        emit NFTSold(msg.sender, seller, tokenId, msg.value);
    }
    
    function getAllListedNFTs() public view returns (uint256[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < _allMintedNFTs.length; i++) {
            if (_listings[_allMintedNFTs[i]].isListed) {
                count++;
            }
        }
        
        uint256[] memory listedNFTs = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < _allMintedNFTs.length; i++) {
            if (_listings[_allMintedNFTs[i]].isListed) {
                listedNFTs[index] = _allMintedNFTs[i];
                index++;
            }
        }
        return listedNFTs;
    }
}
