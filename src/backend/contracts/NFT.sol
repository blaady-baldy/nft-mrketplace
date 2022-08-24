// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage, Ownable {
    address private s_creator;
    uint256 public tokenCount;

    modifier tokenExist(uint256 _tokenId) {
        require(_exists(_tokenId), "Token Doesn't exist!");
        _;
    }

    //Events
    event Brands__Not_Owner();

    constructor() payable ERC721("Ombre NFT", "Ombre") {
        tokenCount = 0;
        s_creator = msg.sender;

    }

    //*****************************************************************************************/
    //                               SETTER FUNCTIONS
    //*************************************************************************************** */

    // MINTING THE NFT

    function mint(
        string memory _tokenURI
    ) public {

        uint256 tokenId = tokenCount;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        tokenCount++;
    }

    //TRANSFERING OWNERSHIP OF NFT TOKEN

    function transferToken(address _sendTo, uint256 _tokenId) public tokenExist(_tokenId) {
        if ((ownerOf(_tokenId) == msg.sender)) {
            safeTransferFrom(msg.sender, _sendTo, _tokenId);
        } 
        // else revert Brands__Not_Owner();
    }


    //CHECKS IF THE CURRENT ACCOUNT IS OWNER OF THE GIVEN NFT OR NOT

    function isOwner(uint256 _tokenId) public view tokenExist(_tokenId) returns (bool) {
        if (msg.sender == ownerOf(_tokenId)) {
            return true;
        } else {
            return false;
        }
    }

    // RETURNS THE TOKEN URI OF THE TOKEN

    function viewTokenURI(uint256 _tokenId)
        public
        view
        tokenExist(_tokenId)
        returns (string memory)
    {
        return tokenURI(_tokenId);
    }

    // RETURNS THE TOTAL TOKENS THAT HAVE BEEN MINTED

    function getTotalySupply() public view returns (uint256) {
        return tokenCount;
    }

}