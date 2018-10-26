pragma solidity ^0.4.24;
import "./Owned.sol";
import "./InvestPlatformI.sol";
import "./AssetTokens.sol";

contract InvestmentPlatform is Owned {
    
    mapping(address => bool) approvedInvestors;
    event LogCreateAsset(address indexed owner, bytes32 name, uint totalSupplyTokens, uint priceToken);
    event LogSetStatus(address indexed investor, bool status);
    
    function createNewAsset(address assetOwner, bytes32 name, uint totalSupplyTokens, uint priceToken) 
    fromOwner public returns(AssetTokens _newAssetTokens) {
        require(approvedInvestors[assetOwner], "Asset owner is not an approved investor");
        AssetTokens newAssetTokens = new AssetTokens(name, totalSupplyTokens, priceToken, address(this));
        newAssetTokens.setOwner(assetOwner);
        emit LogCreateAsset(assetOwner, name, totalSupplyTokens, priceToken); 
        return newAssetTokens;
    }
    
    function setInvestorStatus(address investor, bool status) public fromOwner returns(bool success) {
        require(approvedInvestors[investor] != status, "status already set to this value");
        approvedInvestors[investor] = status ;
        emit LogSetStatus(investor, status);
        return true;
    }
    
    function getInvestorStatus(address investor) public view returns (bool status) {
        return approvedInvestors[investor];
    }
    
    function deleteAsset (address assetAdress) public fromOwner returns (bool success)  {
        AssetTokens asset = AssetTokens(assetAdress);
        asset.killAsset();
        return true;
    }
}