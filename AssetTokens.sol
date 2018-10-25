pragma solidity 0.4.24;
import "./SafeMath.sol";
import "./Owned.sol";

contract AssetTokens is Owned {
    using SafeMath for uint;
    
    enum Status {Open, Closed}  
           
    bytes32 name;
    bytes32 public symbol;
    uint public  totalSupplyTokens;
    uint public priceToken;
    mapping(address => uint) balances;
    mapping(address => uint) allowed;
    Status public status;

    address buyer;
    uint salePrice;

    event LogAssetCreated(bytes32 name, bytes32 symbol, uint totalSupply, uint price, address indexed owner);
    event LogTransfer(address indexed payee, uint tokens);
    event LogApproval(address indexed investor, uint tokens);
    event LogWithdrawal(uint amount);
    event LogAprroveSaleAsset(address indexed buyer, uint salePrice);

    modifier isOpen {
        require(status == Status.Open, "Status is not open`");
        _;
    }

    constructor (bytes32 _name, bytes32 _symbol, uint _totalSupplyTokens, uint _priceToken) public {
        name = _name;
        symbol = _symbol;
        totalSupplyTokens = _totalSupplyTokens;
        priceToken = _priceToken;
        balances[getOwner()] = _totalSupplyTokens;        
        status = Status.Open;
        emit LogAssetCreated(_name, _symbol, _totalSupplyTokens, _priceToken, getOwner());
    }

/*    
    function approve(address investor, uint tokens) isOpen fromOwner public returns (bool success) {
        require(balances[getOwner()] >= tokens, "Unsufficient funds for approval");
        allowed[investor] = tokens;
        emit LogApproval(investor, tokens);
        return true;
    }
*/
    function sellTokens(uint tokens) isOpen public payable returns (bool success) {
        require(allowed[msg.sender] >= tokens, "amount higher than allowed");
        require(msg.value >= tokens.mul(priceToken), "Not enough ether for purchase");
        balances[getOwner()] -= tokens;
        balances[msg.sender] += tokens;
        emit LogTransfer(msg.sender, tokens);
        return true;
    }
    
    function withdrawalWhileOpen(uint amount) isOpen fromOwner public payable {
        getOwner().transfer(amount);
        emit LogWithdrawal(amount);
    }
    
    function approveSaleAsset(address _buyer, uint _salePrice) isOpen fromOwner public (bool sucess) {
        buyer = _buyer;
        salePrice = _salePrice;
        emit LogAprroveSaleAsset(_buyer, _salePrice);
        return true;
    }  
    
    function () public payable {
        revert();
    }


}

