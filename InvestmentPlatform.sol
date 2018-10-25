pragma solidity 0.4.24;

import "./Owned.sol";
import "./AssetTokens.sol";

contract InvestmentPlatform is Owned {
    
    mapping(address => bool) assets;
    event LogCreateAsset(address indexed owner, bytes32 name, uint totalSupplyTokens, uint priceToken);
    
    function createNewAsset(address _owner, bytes32 name, uint totalSupplyTokens, uint priceToken) 
    fromOwner public returns(AssetTokens _newAssetTokens) {
    
        AssetTokens newAssetTokens = new AssetTokens(name, totalSupplyTokens, priceToken);
        newAssetTokens.setOwner(_owner);
        assets[newAssetTokens] = true;
        emit LogCreateAsset(msg.sender, name, totalSupplyTokens, priceToken); 
        return newAssetTokens;
    }
    
    
}