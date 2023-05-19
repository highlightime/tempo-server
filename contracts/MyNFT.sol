//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract MyNFT is ERC721Enumerable,ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => address[]) private _likes;
    mapping(uint256 => address[]) private _dislikes;

    event MintEvent(uint256 newItemId, string tokenURI);
    event LikeEvent(uint256 tokenId, address user);
    event DislikeEvent(uint256 tokenId, address user);


    constructor() ERC721("MyNFT", "NFT") {}

    function mintProfile(address user, string memory _tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(user, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        emit MintEvent(newItemId, _tokenURI);

        return newItemId;
    }

     function tokensOfOwner(address _owner)external view returns(
        uint[] memory
    ){
        uint tokenCount =balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);

        for(uint i=0;i<tokenCount;i++){
            tokensId[i]=tokenOfOwnerByIndex(_owner,i);
        }
        return tokensId;
    }

    function addLike(uint256 tokenId, address user) external {
        require(_exists(tokenId), "Profile does not exist");
        _likes[tokenId].push(user);

        emit LikeEvent(tokenId, user);
    }

    function addDislike(uint256 tokenId, address user) external {
        require(_exists(tokenId), "Profile does not exist");
        _dislikes[tokenId].push(user);

        emit DislikeEvent(tokenId, user);
    }

    function getLikes(uint256 tokenId) external view returns (address[] memory) {
        require(_exists(tokenId), "Profile does not exist");
        return _likes[tokenId];
    }

    function getDislikes(uint256 tokenId) external view returns (address[] memory) {
        require(_exists(tokenId), "Profile does not exist");
        return _dislikes[tokenId];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
        ERC721Enumerable._beforeTokenTransfer(from, to, tokenId,batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
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