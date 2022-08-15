// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint public totalSupply = 100;

    uint public price = 0.01 ether;

    uint public maxPerUser = 5;

    address public owner;

    uint public balance;

    string public image = 'ipfs://QmdnjkbWezYMJ8ssjGKGyC8YfXRJWcYGAM5XqWFUPpbWis';

    constructor() ERC721("MyToken", "MTK") {
        owner = msg.sender;
    }

    function safeMint(uint256 numberOfNfts) public payable {
        require(msg.value >= price, 'insufficient funds');
        require(numberOfNfts < maxPerUser, 'cannot mint more than 5 NFTs');
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, image);
    }

    function withdraw() public {
        require(msg.sender == owner, 'You have to be the owner to make this call');
        (bool success, ) = msg.sender.call{value: totalSupply}("");
        require(success, "function 'withdraw' failed!");
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}