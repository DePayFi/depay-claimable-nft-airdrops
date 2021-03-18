// SPDX-License-Identifier: MIT
pragma solidity >=0.7.5 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/utils/ReentrancyGuard.sol";

contract DePayNFTAirdropV1 is Ownable, ReentrancyGuard {

    // Storage for all airdrops to identify executed/canceled airdrops
    mapping (
      // receiver address
      address => mapping (
        // token address
        address => mapping (
          // token id
          uint256 => bool
        )
      )
    ) public airdrops;

    // Being able to pause the aidrop contract (just in case)
    bool public paused;

    // EIP712
    string private constant domain = "EIP712Domain(string name)";
    bytes32 public constant domainTypeHash = keccak256(abi.encodePacked(domain));
    string private constant airdropType = "Airdrop(address tokenAddress,address[] receivers,bool isERC1155,uint256[] tokenIds)";
    bytes32 public constant airdropTypeHash = keccak256(abi.encodePacked(airdropType));
    bytes32 private domainSeparator;

    //
    struct Airdrop {
      //
      // The address of the token contract
      //
      address tokenAddress;
      //
      // Addresses of users which are allowed to withdrawal an airdrop
      //
      address[] receivers;
      //
      // Indicates the NFT standard if standard supports ERC1155 or not
      //
      bool isERC1155;
      //
      // TokenIds
      //
      uint256[] tokenIds;
    }
    
    //
    modifier onlyUnpaused {
      require(paused == false, "Airdrops are paused!");
      _;
    }

    ////////////////////////////////////////////////
    //////// C O N S T R U C T O R
    //
    // Initalizes the EIP712 domain separator.
    //
    constructor() public {
      domainSeparator = keccak256(abi.encode(
        domainTypeHash,
        keccak256("DePayNFTAirdropV1")
      ));
    }

    ////////////////////////////////////////////////
    //////// F U N C T I O N S
    //
    // Claim an aidroped NFT
    //
    function claim(
      address tokenAddress,
      address[] memory receivers,
      bool isERC1155,
      uint256[] memory tokenIds,
      uint256 index,
      uint8 v,
      bytes32 r,
      bytes32 s
    ) onlyUnpaused nonReentrant external {
      address distributor = ecrecover(
        hashAirdrop(
          tokenAddress,
          receivers,
          isERC1155,
          tokenIds
        ),
        v,
        r,
        s
      );

      uint256 tokenId = tokenIds[index];
      address receiver = receivers[index];
      require(receiver == msg.sender, "Defined airdrop receiver needs to be msg.sender!");

      require(airdrops[receiver][tokenAddress][tokenId] == false, "Receiver has already retrieved this airdrop!");
      airdrops[receiver][tokenAddress][tokenId] = true;

      if(isERC1155) { // ERC1155
        IERC1155 token = IERC1155(tokenAddress);
        token.safeTransferFrom(distributor, receiver, tokenId, 1, bytes(""));
      } else { // ERC721
        IERC721 token = IERC721(tokenAddress);
        token.safeTransferFrom(distributor, receiver, tokenId);
      }
    }

    
    //
    // Internal, private method to hash an airdrop
    //
    function hashAirdrop(address tokenAddress, address[] memory receivers, bool isERC1155, uint256[] memory tokenIds) private view returns (bytes32){
      return keccak256(abi.encodePacked(
        "\x19\x01",
        domainSeparator,
        keccak256(abi.encode(
          airdropTypeHash,
          keccak256(abi.encodePacked(tokenAddress)),
          keccak256(abi.encodePacked(receivers)),
          keccak256(abi.encodePacked(isERC1155)),
          keccak256(abi.encodePacked(tokenIds))
        ))
      ));
    }

    //
    // Change set paused to
    //
    function setPausedTo(bool value) external onlyOwner {
      paused = value;
    }

    //
    // Kill contract
    //
    function kill() external onlyOwner {
      selfdestruct(msg.sender);
    }
}
