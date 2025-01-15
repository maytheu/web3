## Migrations

Contains smart contracts migration on the blockchain to new addresses

using truffle

Initialize truffle project

`truffle init`

Compile the code

`truffle compile`

deploy ot the blockchain add reset flag for other migrations

`truffle migrate --reset`

Test the contract locally

`truffle console`

In the truffle editor

`let krypto  = await KryptoBirdz.deployed()`

` krypto.symbol()`

Should show the value