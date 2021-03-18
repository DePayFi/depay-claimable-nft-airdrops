# DePay's Ethereum Router

Plugin based ethereum smart contract enabling various peer-to-peer transactions like:
Payments, Subscriptions, Sales, Swaps, Payroll and Credit.

## Deployments

#### Mainnet

[DePayRouterV1 0xae60ac8e69414c2dc362d0e6a03af643d1d85b92](https://etherscan.io/address/0xae60ac8e69414c2dc362d0e6a03af643d1d85b92)

#### Ropsten

[DePayRouterV1 0x82154ea9c2dc4c06d6719ce08728f5cfc9422b1d](https://ropsten.etherscan.io/address/0x82154ea9c2dc4c06d6719ce08728f5cfc9422b1d)

## Summary

This set of smart contracts enables decentralized payments.

The main purpose of this smart contract evolves around the `route` function,
which allows a sender to route crypto assets while converting tokens as part of the same transaction if required.

This allows for ETH to ETH, tokenA to tokenA, ETH to tokenA, tokenA to ETH and tokenA to tokenB conversions as part of e.g. payments.

To increase functionalities and to enable more and future decentralized exchanges and protocols,
additional plugins can be added/approved by calling `approvePlugin`.

## Functionalities

### `route` Route Transactions

The main function to route transactions.

Arguments:

`path`: The path of the token conversion:

```
ETH to ETH: 
['0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE']

DEPAY to DEPAY: 
['0xa0bEd124a09ac2Bd941b10349d8d224fe3c955eb']

ETH to DEPAY: 
['0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE', '0xa0bEd124a09ac2Bd941b10349d8d224fe3c955eb']

DEPAY to ETH: 
['0xa0bEd124a09ac2Bd941b10349d8d224fe3c955eb', '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE']

DEPAY to UNI (routing goes through WETH): 
['0xa0bEd124a09ac2Bd941b10349d8d224fe3c955eb', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984']
```

`amounts`: Amounts passed to proccessors:

```
e.g. [amountIn, amountOut, deadline]
```

`addresses`: Addresses passed to proccessors:

```
e.g. [receiver]
or [for, smartContractReceiver]
```

`plugins`: List of plugins to be executed in the given order for this payment:

```
e.g. [DePayRouterV1Uniswap01,DePayRouterV1Payment01] to swap and pay
or [DePayRouterV1Uniswap01,DePayRouterV1ApproveAndCallContractAddressAmount01] to swap and call another contract
```
See [Approved Plugins](#approved-plugins) for more details about available and approved plugins.

`data`: Additional data passed to the payment plugins (e.g. contract call signatures):

```
e.g. ["signatureOfSmartContractFunction(address,uint)"] receiving the payment
```

### `approvePlugin` Approves a plugin.

`plugin`: Address for the plugin to be approved.

## Approved Plugins

### DePayRouterV1Payment01

Used to send a payment (ETH or any transferable token) to a receiver.

Sends the token of path at the last position (`path[path.length-1]`) for the amount at index 1 (`amounts[1]`) to the address at the last position (`addresses[addresses.length-1]`).

Can be used to perform token sales from decentralized exchanges to the sender by setting `addresses` to `[<sender address>]`.

Mainnet: [0x99F3F4685a7178F26EB4F4Ca8B75a1724F1577B9](https://etherscan.io/address/0x99f3f4685a7178f26eb4f4ca8b75a1724f1577b9)

Ropsten: [0x7C9cfd8905E8351303b0bE5D8378b3D453532c44](https://ropsten.etherscan.io/address/0x7c9cfd8905e8351303b0be5d8378b3d453532c44)

### DePayRouterV1PaymentEvent01

Used to log a payment event on-chain if requested. If not required/requested, not using it does safe gas.

Emits a `Payment` event on the `DePayRouterV1PaymentEvent01` contract using `addresses[0]` as the `sender` of the event and `addresses[addresses.length-1]` as the `receiver` of the `Payment`.

Mainnet: [0xDDe66e253aCb96E03E8CAcEc0Afb9308f496c732](https://etherscan.io/address/0xdde66e253acb96e03e8cacec0afb9308f496c732)

Ropsten: [0x076f1f13efA6b194f636E265856D0381704fC394](https://ropsten.etherscan.io/address/0x076f1f13efa6b194f636e265856d0381704fc394)

### DePayRouterV1SaleEvent01

Used to log a sale event on-chain if requested. If not required/requested, not using it does safe gas.

Emits a `Sale` event on the `DePayRouterV1SaleEvent01` contract using `addresses[0]` as the `buyer`.

Mainnet: [0xA47D5E0e6684D3ad73F3b94d9DAf18a2f5F97688](https://etherscan.io/address/0xa47d5e0e6684d3ad73f3b94d9daf18a2f5f97688)

Ropsten: [0x78AC73A852BB11eD09Cb14CAe8c355A4C0fAC476](https://ropsten.etherscan.io/address/0x78ac73a852bb11ed09cb14cae8c355a4c0fac476)

### DePayRouterV1Uniswap01

Swap tokenA to tokenB, ETH to tokenA or tokenA to ETH on Uniswap as part of the payment.

Swaps tokens according to provided `path` using the amount at index 0 (`amounts[0]`) as input amount,
the amount at index 1 (`amounts[1]`) as output amount and the amount at index 2 (`amount[2]`) as deadline.

Mainnet: [0xe04b08Dfc6CaA0F4Ec523a3Ae283Ece7efE00019](https://etherscan.io/address/0xe04b08dfc6caa0f4ec523a3ae283ece7efe00019)

Ropsten: [0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268](https://ropsten.etherscan.io/address/0xc1f6146f45b6ec65fa9e8c8e278bb01879b32268)

### DePayRouterV1ApproveAndCallContractAddressAmount01

Call another smart contract to deposit an amount for a given address while making sure the amount passed to the contract is approved.

Approves the amount at index 1 of `amounts` (`amounts[1]`)
for the token at the last position of `path` (`path[path.length-1]`)
to be used by the smart contract at index 1 of `addresses` (`addresses[1]`).

Afterwards, calls the smart contract at index 1 of `addresses` (`addresses[1]`),
passing the address at index 0 of `addresses` (`addresses[0]`)
and passing the amount at index 1 of `amounts` (`amounts[1]`)
to the method with the signature provided in `data` at index 0 (`data[0]`).

Mainnet: [0x6F44fF404E57Ec15223d58057bd28519B927ddaB](https://etherscan.io/address/0x6f44ff404e57ec15223d58057bd28519b927ddab)

Ropsten: [0x60cc73eb2b2B983554C9f66B26115174eD2C6335](https://ropsten.etherscan.io/address/0x60cc73eb2b2b983554c9f66b26115174ed2c6335)


## Examples

### tokenA to tokenB payment with smart contract receiver (e.g. staking pool)

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x6040567eef6538ec092fc7cc06eb00af00674b0287b21d3d192ad0f3daa711cb

`path` needs to go through tokenA -> WETH -> tokenB if executed by Uniswap.

Requires to approve token at first index of path to be approved for the payment protocol smart contract.

Get amounts through the Uniswap router by passing the same `path` and the desired output amount to receive the required input amount.

```
value: 0

path: ["0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB","0xc778417E063141139Fce010982780140Aa0cD5Ab","0x9c2Db0108d7C8baE8bE8928d151e0322F75e8Eea"]

amounts: ["8551337980759167135310","1000000000000000000","1711537544"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950","0x0d8A34Cb6c08Ec71eA8009DF725a779B1877d4c5"]

plugins: ["0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268","0x60cc73eb2b2B983554C9f66B26115174eD2C6335"]

data: ["depositFor(address,uint256)"]
```

`Gas usage: approx. 304,000`

### tokenA to tokenB payment

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x03b34fa7b08ad05cb9a74759bf7de0d45197f4b41f0b81509b9fba1cb684d039

`path` needs to go through tokenA -> WETH -> tokenB if executed by Uniswap.

Requires to approve token at first index of path to be approved for the payment protocol smart contract.

Get amounts through the Uniswap router by passing the same `path` and the desired output amount to receive the required input amount.

```
value: 0

path: ["0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB","0xc778417e063141139fce010982780140aa0cd5ab","0x1f9840a85d5af5bf1d1762f925bdaddc4201f984"]

amounts: ["10187046138967433440396","10000000000000000","1711537544"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950"]

plugins: ["0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268","0x7C9cfd8905E8351303b0bE5D8378b3D453532c44"]

data: []
```

`Gas usage: approx. 253,000`

IMPORTANT: Don't forget to use the actual payment plugin at the end of `plugins`
to avoid depositing swaps into the payment contract itself (without performing a payment).

### tokenA to ETH payment

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0xe8536f159ef4302ca5cea76c4bdf1fb7d0bf555f183d1655953a6939e4ee84d2

```
value: "0"

path: ["0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB","0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"]

amounts: ["1735972857185674397500","10000000000000000","1711537544"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950"]

plugins: ["0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268","0x7C9cfd8905E8351303b0bE5D8378b3D453532c44"]

data: []
```

`Gas usage: approx. 213,000`

IMPORTANT: Don't forget to use the actual payment plugin at the end of `plugins`
to avoid depositing swaps into the payment contract itself (without performing a payment).

### ETH to tokenA payment

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x5aa12899c7bfb6f48806a1ad859e2f0e6535f3d49fa6cf73d41b9fffa677ca85

```
value: "5997801900122"

path: ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE","0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB"]

amounts: ["5997801900122","1000000000000000000","1711537544"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950"]

plugins: ["0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268","0x7C9cfd8905E8351303b0bE5D8378b3D453532c44"]

data: []
```

`Gas usage: approx. 172,000`

IMPORTANT: Don't forget to use the actual payment plugin at the end of `plugins`
to avoid depositing swaps into the payment contract itself (without performing a payment).

### Sale (sell tokens from open decentralized exchanges)

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x4cb1ebfdb6d13a6a2b1a19be5cf93a8a704ba30c53408dbb79b8d67543235df4

```
value: "5998045319783"

path: ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE","0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB"]

amounts: ["5998045319783","1000000000000000000","1711537544"]

addresses: ["0x317D875cA3B9f8d14f960486C0d1D1913be74e90"]

plugins: ["0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268","0x7C9cfd8905E8351303b0bE5D8378b3D453532c44"]

data: []
```

`Gas usage: approx. 172,000`

IMPORTANT: Make sure to set the address of the purchaser (sender == receiver) and to use the actual payment plugin to send the swap back to the purchaser.

### Log sale event

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x679e3cbe6f0a8934d4413beff5bffcbd6b23ba0e240038ff98001965368d4cc0

```
value: "5998045319783"

path: ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE","0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB"]

amounts: ["5998045319783","1000000000000000000","1711537544"]

addresses: ["0x317D875cA3B9f8d14f960486C0d1D1913be74e90"]

plugins: ["0xc1F6146f45b6EC65FA9E8c8E278bb01879b32268","0x7C9cfd8905E8351303b0bE5D8378b3D453532c44","0x78AC73A852BB11eD09Cb14CAe8c355A4C0fAC476"]

data: []
```

`Gas usage: approx. 187,000`

IMPORTANT: The sale log event will be emited on the sale event plugin itself and will be part of the transaction.

### tokenA to tokenA payment

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x473d4683d9a52034b120a6309db08745790a136017d2adfe36f1153037d19250

_Consider performing tokenA to tokenA transfers directly if you don't rely on any other plugins or the payment event._

_Needs spending approval on path[0] token contract for the router (spender) first._

```
value: "0"

path: ["0xAb4c122a024FeB8Eb3A87fBc7044ad69E51645cB"]

amounts: ["10000000000000000","10000000000000000"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950"]

plugins: ["0x7C9cfd8905E8351303b0bE5D8378b3D453532c44"]

data: []
```

`Gas usage: approx. 80,000`

IMPORTANT: Don't forget to use the actual payment plugin at the end of `plugins`
to avoid depositing into the payment contract itself without performing a payment.

### ETH to ETH payment

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0xd2d271463298d98130117e9ec3f29dd702ce1aab9fe2574452c5a1adc32826fa

_Consider performing ETH to ETH transfers directly and not via the DePayRouter, if you don't rely on any other plugin, in order to save gas._

```
value: "10000000000000000"

path: ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"]

amounts: ["10000000000000000","10000000000000000"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950"]

plugins: ["0x7C9cfd8905E8351303b0bE5D8378b3D453532c44"]

data: []
```

`Gas usage: approx. 48,400`

IMPORTANT: Don't forget to use the actual payment plugin at the end of `plugins`
to avoid just depositing into the payment contract itself without performing a payment.

### Log payment event

Mainnet: [XXX](XXX)

Ropsten: https://ropsten.etherscan.io/tx/0x9ada66ede69fbff9f61ac9d6c3f24c2f6de6dd7d53c0a982e8ea7070a1e92c31

```
value: "10000000000000000"

path: ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"]

amounts: ["10000000000000000","10000000000000000"]

addresses: ["0x08B277154218CCF3380CAE48d630DA13462E3950"]

plugins: ["0x7C9cfd8905E8351303b0bE5D8378b3D453532c44","0x076f1f13efA6b194f636E265856D0381704fC394"]

data: []
```

`Gas usage: approx. 63,800`

IMPORTANT: The payment log event will be emited on the payment event plugin itself and will be part of the transaction.

## Security Audits

1. https://github.com/DePayFi/depay-ethereum-payments/blob/master/docs/Audit1.md
2. https://github.com/DePayFi/depay-ethereum-payments/blob/master/docs/Audit2.md
3. https://github.com/DePayFi/depay-ethereum-payments/blob/master/docs/Audit3.md

## Development

### Quick Start

```
yarn install
yarn test
```

### Testing

```
yarn test
```

or to run single tests:
```
yarn test -g 'deploys router successfully'
```

### Deploy

1. `yarn flatten`

2. Deploy flatten contract via https://remix.ethereum.org/
