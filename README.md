# DePay's Claimable NFT Airdrops

Smart contract allowing to airdrop NFTs without sending them to the receivers
but instead having receivers withdrawal them through the airdrop contract.

Airdrop distributors reate off-chain signatures that can be used by the
airdrop receiver to redeem them for the NFT.

## Deployments

#### Mainnet

[DePayNFTAirdropV1 XXX](XXX)

#### Ropsten

[DePayNFTAirdropV1 0x1ceadd57e477901499c08aec5d2044cc3430d7fc](https://ropsten.etherscan.io/address/0x1ceadd57e477901499c08aec5d2044cc3430d7fc)

[ERC721 0xe7f982e9f25471bc1dd6a84a5433274834d7853f9b49357ece40538ce2c5d7af](https://ropsten.etherscan.io/tx/0xe7f982e9f25471bc1dd6a84a5433274834d7853f9b49357ece40538ce2c5d7af)

[ERC1155 0xb6bb75ae8af249891b1cdcb92a6cb74c6c1b30f8](https://ropsten.etherscan.io/address/0xb6bb75ae8af249891b1cdcb92a6cb74c6c1b30f8)

## Functionalities

### `claim` Claim NFT

The main function allowing people to redeem off-chain airdrop signatures for NFTs.

Arguments:

`address tokenAddress`: The address of the NFT to be claimed.

`address[] receivers`: An array of all receivers, required to validate off-chain signatures.

`bool isERC1155`: Boolean indicating if the airdrop token is a ERC1155 (otherwise falling back to ERC721).

`uint256[] tokenIds`: Ids of all airdroped NFT tokens, required to validate off-chain signatures.

`uint256 index`: Position/index of the current receiver within `receivers` and `tokenIds`.

`uint8 v`: `v` of the off-chain signature.

`bytes32 r`: `r` of the off-chain signature.

`bytes32 s`: `s` of the off-chain signature.

### Deploy

1. `yarn flatten`

2. Deploy flatten contract via https://remix.ethereum.org/
