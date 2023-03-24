// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FirstNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;
    uint256 maxSupply = 1000;
    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;
mapping(address => bool) public allowList;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FirstNFT", "FNFT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    
    //to change the state of minting - open or close minting [access ony to owner]

function editMintWindow(
    bool _publicMintOpen,
    bool _allowListMintOpen
)external onlyOwner {
    publicMintOpen=_publicMintOpen;
allowListMintOpen=_allowListMintOpen;
}

//allowListMint is only previlaged people could buy nft jus like airdropping 
    function allowListMint() public payable{
        require(allowListMintOpen,"ALlowListMint Closed");
        require(allowList[msg.sender],"Your address can't use allowlist");
        require(msg.value==0.001 ether, "Not sufficient fund");
        require(totalSupply()<maxSupply,"We sold out");
         uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId); 
    }
    
//to allow people to mint at normal price 

    function publicMint() public  payable{
        require(publicMintOpen,"publicMint Closed");
        require(msg.value==0.01 ether, "Not sufficient fund");
        require(totalSupply()<maxSupply,"We sold out");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        // _setTokenURI(tokenId, uri);
    }
//to withdraw the amount from the contract address - Access only to owner

function withdraw(address _addr) external onlyOwner{
    //get the balance of the contract
    uint256 balance = address(this).balance;
    payable(_addr).transfer(balance);
}
//the provided address will get previlage to Mint NFT at lower price

function setAllowList(address[] calldata addresses) external onlyOwner{
for(uint256 i=0;i<addresses.length;i++){
    allowList[addresses[i]]=true;

}
}

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
