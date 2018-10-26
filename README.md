# Investment Platform for Tangible Assets
This platform allows investments on Tangible Assets by buying and selling tokens that represent a share in the value of an asset.
There are two potential type of investors that can benefit from this platform:

  - Asset Holders: this type of investor seeks to sell tokens that represent a share of the asset. With the money obtained, they can perform enchancements on the asset to increase their sell value. Example: owners of luxury appartments that wish to obtain liquidity to perform renovations and enhacements on the property for increasing the chances of a higher price when selling it.
  - Token Holders: Investors that want to exchange ether to buy tokens that represent a share on the final price of an asset. 

Apart from the investors, there is a another important participant in the platform: the administrator. This entity carries out a very important duty: to vet the individuals that wish to invest through the platform. These validations wil be performed off-chain, but once the individual has passed any AML/KYC checks, the administrator will activate the flag that allows the given investor start buying or selling tokens. 



The main two artifacts of the implementation are the following two smart contracts implemented on Solidity:

```sh
AssetTokens.sol
InvestmentPlatform.sol
```
Furthermore, the implementation also features the common `Owned.sol`, and `SafeMath.sol`.


# AssetTokens.sol

This contract holds the core of the implementation. 
The lifecycle of the contract comprises the following stages:

1 - Creation: the constructor will populate the asset with the basic variables. Name of the asset, number of tokens and price of the token. Ideally, the number of tokens multiplied by their price should equal the current value of the asset at the moment of the contract creation. Once the contract gets deployed, its status is set to open and investors can purchase tokens on it.

2 - Investment: any potential investor that wants to buy tokens on the asset, will need to send a transaction invoking fuction `sellTokens()` with the right amount of ether. Besides, the contract will validate that the investor has been previously vetted and is allowed to participate. The owner of the asset will have access to the ether collected by the tokens sale by invoking the function `withdrawalWhileOpen()`. This ether can be used to improve the value of the asset and attract more buyers. 

3 - Asset sale: the investment stage will carry on until the owner finds a buyer for the asset. Because this is an important stage, and the transaction is going to involve a significant amount of ether, this stage can only be executed by the Administrator of the platform, who will authorize the sale by invoking `approveSaleAsset()` and indicating the account where the funds for the purchase will come from. Off-chain, the administrator will have previously validated that the buyer has performed any other legal checks to allow for the asset transfer. (Ex: in the case of a property, the corresponding Stamp Duty)

4 - Asset sale: once the the sale has been approved, the account that belongs to the owner will invoke function `sellAsset()` attaching the right amount of ether. At that moment, the contract goes to status closed, preventing any further tokens sale.

5 - Withdrawal: once the contract has been closed, the investors can withdraw their share of the final price by calling the `withdrawal()` function. The owner of the asset can also call this function to exchange his remaining tokens. 

6 - Kill: once all the contract balance has been emptied, the administrator of the platform can all function `killAsset()` to remove the contract from the ethereum blockchain.

# InvestmentPlatform.sol
This contract will serve as a hub to manage all the different investments in the the platform. It is on this contract that the administrator (owner) will activitate the status of the investors. Investors that have passed all the KYC/AML checks will have the flag activated on the mapping on this contract, allowing the tokens sale. 
The administrator will be in charge of creating the asset contracts only once they have gone through the due dilligence with the asset holder. 
In summary, this contract will be used by the administrator of the platform to :

    - Create a new Asset token sale (ie: create a AssetTokens contract)
    - Delete the contract once the asset has been sold
    - Manage the status of the investors that can participate in the platform.

Any questions, you can find me at juliods@gmail.com.

