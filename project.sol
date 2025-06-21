// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTMarketplace {
    struct NFT {
        uint256 id;
        address payable seller;
        address owner;
        uint256 price;
        bool listed;
    }

    uint256 public nftCount = 0;
    mapping(uint256 => NFT) public nfts;

    event NFTListed(uint256 indexed id, address seller, uint256 price);
    event NFTSold(uint256 indexed id, address buyer, uint256 price);

    // List an NFT for sale
    function listNFT(uint256 _id, uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");
        nftCount++;
        nfts[_id] = NFT(_id, payable(msg.sender), address(this), _price, true);

        emit NFTListed(_id, msg.sender, _price);
    }

    // Buy a listed NFT
    function buyNFT(uint256 _id) external payable {
        NFT storage nft = nfts[_id];
        require(nft.listed, "NFT not listed for sale");
        require(msg.value >= nft.price, "Insufficient funds sent");

        nft.seller.transfer(msg.value);
        nft.owner = msg.sender;
        nft.listed = false;

        emit NFTSold(_id, msg.sender, nft.price);
    }

    // Get NFT details
    function getNFT(uint256 _id) external view returns (NFT memory) {
        return nfts[_id];
    }
}
