// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract VotingEngine {
    uint public constant REQUIRED_SUM = 10000000000000000; // сколько надо платить
    uint public constant FEE = 10; // 10%
    address public owner;

    struct Voting {
        string title;
        mapping (address => uint) candidates;
        address[] allCandidates;
        bool started;
        bool ended;
        bool exists;
        uint totalAmount;
        mapping (address => address) participants; // голосовавшие и за кого голосовали
        address[] allParticipants;
        uint endsAt; // когда заканчиваем?
        uint maximumVotes;
        address winner;
        
    }
    Voting[] public votings;

    constructor() {
        owner = msg.sender;
    }

    function addVoting(string memory _title) external onlyOwner {
      Voting storage newVoting = votings.push();
      newVoting.title = _title;
    }

    // добавить себя кандидатом
    function addCandidate(uint index, address candidate) external onlyOwner {
        votings[index].allCandidates.push(candidate);
    }

    function startVoting(uint index) external onlyOwner {
        votings[index].started = true;
        votings[index].exists = true;
        votings[index].endsAt = block.timestamp + 3 days;
    }

    function withdraw(uint index) external onlyOwner {
         require(votings[index].exists && (votings[index].ended));
          uint sum = 0.01 ether * votings[index].allParticipants.length;
         (bool sent,) = votings[index].winner.call{value: (sum * 10 / 100)}("");
                 assert(sent);
    }

    function stopVoting(uint index) external {
        require(block.timestamp >= votings[index].endsAt);
        require(votings[index].exists && (votings[index].started && !votings[index].ended));
        address thisContract = address(this);
        votings[index].ended = true;
        uint sum = 0.01 ether * votings[index].allParticipants.length;
        (bool sent,) = votings[index].winner.call{value: (sum * 10 / 100)}("");
                 assert(sent);

    }

    function vote(uint index, address candidate) external payable {
        require(votings[index].exists && (votings[index].started && !votings[index].ended));
        // require(votings[index].allCandidates[candidate].exists);
        // require(!votings[index].allParticipants[msg.sender].exists); // по какой-то причине эти две прокерки перестали работать, не смог решить проблему
        require(msg.value >= 0.01 ether);
        votings[index].candidates[candidate] += 1;
        votings[index].allParticipants.push(msg.sender);
        votings[index].participants[msg.sender] = candidate;
        
        votings[index].maximumVotes = votings[index].maximumVotes > 
        votings[index].candidates[candidate]
         ? votings[index].maximumVotes 
         : votings[index].candidates[candidate];

         votings[index].winner = votings[index].maximumVotes > 
        votings[index].candidates[candidate]
         ? votings[index].winner 
         : candidate;

    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //разбить рекваиры и добавить коды ошибок
    // require(
    //         msg.sender == chairperson,
    //         "Only chairperson can give right to vote."
    //     );
}