# fund_me_vyper

This repo is the Vyper version of the [brownie_fund_me](https://github.com/PatrickAlphaC/brownie_fund_me) from [Patrick Collins](https://github.com/PatrickAlphaC).
This repo contains an exemple of how to integrate the ChainLink pricefeed for the ETH/USD pair in Vyper.

Feel free to pull a request or an issue if you figure out how to improve the Vyper code.

# Important note

You have to create your own .env file containing : 
```
export PRIVATE_KEY="YOUR_PRIVATE_KEY"
export WEB3_INFURA_PROJECT_ID="YOUR_INFURA_ID"
```

Only the contract have been changed, the python script for deploying and interacting with the contract are close to the original.

This code is mainly designed to be deployed on the Kovan testnet
