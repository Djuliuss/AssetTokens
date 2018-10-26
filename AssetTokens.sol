pragma solidity ^0.4.24;
import "./SafeMath.sol";
import "./Owned.sol";
import "./InvestPlatformI.sol";

contract AssetTokens is Owned {
    using SafeMath for uint;
    
    enum Status {Open, Closed}  
           
    bytes32 name;
    uint public  totalSupplyTokens;
    uint public priceToken;
    mapping(address => uint) balances;
    Status public status;
    address platform;

    address buyer;
    uint salePrice;

    event LogAssetCreated(bytes32 indexed name, uint totalSupply, uint price, address indexed owner, address indexed platform);
    event LogTransfer(address indexed payee, uint tokens);
    event LogApproval(address indexed investor, uint tokens);
    event LogWithdrawal(uint amount);
    event LogAprroveSaleAsset(address indexed buyer, uint salePrice);
    event LogSellAsset();
    event LogWithdrawShare(address indexed investor);

    modifier isOpen {
        require(status == Status.Open, "Status is not open`");
        _;
    }
    
    constructor (bytes32 _name, uint _totalSupplyTokens, uint _priceToken, address _platform) public {
        name = _name;
        totalSupplyTokens = _totalSupplyTokens;
        priceToken = _priceToken;
        balances[getOwner()] = _totalSupplyTokens;        
        status = Status.Open;
        platform = _platform;
        emit LogAssetCreated(_name, _totalSupplyTokens, _priceToken, getOwner(), _platform);
    }

    function sellTokens(uint tokens) isOpen public payable returns (bool success) {
        require(msg.value >= tokens.mul(priceToken), "Not enough ether for purchase");
        require(InvestmentPlatformI(platform).getInvestorStatus(msg.sender), "Investor not authorized");
        balances[getOwner()] -= tokens;
        balances[msg.sender] += tokens;
        emit LogTransfer(msg.sender, tokens);
        return true;
    }
    
    function withdrawalWhileOpen(uint amount) isOpen fromOwner public payable {
        getOwner().transfer(amount);
        emit LogWithdrawal(amount);
    }
    
    function approveSaleAsset(address _buyer, uint _salePrice) isOpen public returns (bool sucess) {
        require(msg.sender == platform, "Sender is not platform");
        buyer = _buyer;
        salePrice = _salePrice;
        emit LogAprroveSaleAsset(_buyer, _salePrice);
        return true;
    }  
    
    function sellAsset() isOpen public payable returns (bool sucess) {
        require(msg.sender == buyer, "Buyer not authorized");
        require(msg.value >= salePrice, "Attached value not high enough");
        status = Status.Closed;
        emit LogSellAsset();
        return true;
    }
    
    function withdrawShare() public {
        require(status == Status.Closed, "Asset has not been sold yet");
        uint amount = (balances[msg.sender].mul(address(this).balance)).div(totalSupplyTokens);
        balances[msg.sender] = 0;
        emit LogWithdrawShare(msg.sender);
        msg.sender.transfer(amount);
    }
    
    function killAsset() public {
         require(msg.sender == platform, "Sender is not platform");
         require(address(this).balance == 0, "Balance is not zero");
         selfdestruct(platform);
    }
    
    function () public payable {
        revert();
    }


}

