pragma solidity >=0.4.22 <0.9.0;

contract Voting {
    address public owner;
    string contractStartDate = now;
    string constractStopDate;
    uint profit;

    mapping(address => address) public votes;


    constructor() {
        owner = msg.sender;
    }

    function startVoting() external {
        if(now > contractStartDate) {
            console.log('можно начинать голосование')
        }

    }

   
    
    function vote(address candidate) external {
        require(msg.sender != candidate && votes[msg.sender] != address(0));
        votes[msg.sender] = candidate;
    }

    

}