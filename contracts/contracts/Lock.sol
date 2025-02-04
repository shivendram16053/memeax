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

    mapping(uint256 => NFTMetadata) private _nftDetails;

    event NFTMinted(address indexed owner, uint256 indexed tokenId, string metadataURI);

    constructor() ERC721("MemeaxNFT", "MEMEAX") Ownable(msg.sender) {}

    function mintMemeNFT(
        address recipient,
        string memory title,
        string memory description,
        string memory metadataURI
    ) public  returns (uint256) {

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

        emit NFTMinted(recipient, newItemId, metadataURI);
        return newItemId;
    }

    function getAllNFTs() public view returns (uint256[] memory) {
        uint256 totalNFTs = _allMintedNFTs.length;
        uint256[] memory reversedNFTs = new uint256[](totalNFTs);

        for (uint256 i = 0; i < totalNFTs; i++) {
            reversedNFTs[i] = _allMintedNFTs[totalNFTs - 1 - i]; // Reverse order
        }

        return reversedNFTs;
    }

    function getNFTDetails(uint256 tokenId) public view returns (string memory, string memory, string memory, address) {
        NFTMetadata memory metadata = _nftDetails[tokenId];
        return (metadata.title, metadata.description, metadata.metadataURI, metadata.creator);
    }
}