// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OneERC721 is ERC721Enumerable, Ownable {
  string public uri;
  event DonationReceived(address donator, uint256 amount);

  constructor(
    string memory symbol_,
    string memory name_,
    string memory uri_
  ) ERC721Enumerable() ERC721(symbol_, name_) {
    uri = uri_;
  }

  function setUri(string memory _uri) external onlyOwner {
    uri = _uri;
  }

  function _baseURI() internal view override returns (string memory) {
    return uri;
  }

  function addressToId(address account) internal pure returns (uint256) {
    return uint256(uint160(account));
  }

  function hasToken(address account) external view returns (bool) {
    return _exists(addressToId(account));
  }

  function mint() external payable {
    uint256 tokenId = addressToId(msg.sender);
    require(!_exists(tokenId), "token already minted");
    _mint(msg.sender, tokenId);
    if (msg.value > 0) {
      emit DonationReceived(msg.sender, msg.value);
    }
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256
  ) internal pure override {
    if (address(0) != from && address(0) != to) {
      revert("Non transferrable");
    }
  }

  function withdraw() external onlyOwner {
    if (address(this).balance > 0) {
      payable(msg.sender).transfer(address(this).balance);
    }
  }
}
