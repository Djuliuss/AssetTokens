pragma solidity 0.4.24;

contract Owned {

    address private owner;
    event LogOwnerSet(address indexed previousOwner, address indexed newOwner);

    
    modifier fromOwner {
        require(msg.sender == owner, "message sender is not owner");
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }

    function setOwner(address newOwner) fromOwner public returns(bool success) {
        owner = newOwner;
        emit LogOwnerSet(owner, newOwner);
        return true;
    }

    function getOwner() view public returns(address _owner) {
        return owner;
    }

}
