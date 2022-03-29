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

    function addVoting(string memory title) external onlyOwner {
        votings.push(Voting ({title: title}));
    

    }

    // добавить себя кандидатом
    function addCandidate(uint index, address candidate) external onlyOwner {
        votings[index].allCandidates.push(candidate);
        votings[index].candidates[candidate] = votings[index].allCandidates.length;
    }

    function startVoting(uint index) external onlyOwner {
        votings[index].started = true;
        votings[index].endsAt = now + 3day;
    }

    function withdrawAll() {
        address to = payable(owner);
        address thisContract = address(this);
        to.withdraw(thisContract.balance - (thisContract.balance * 0.1)) // выводим все, кроме коммисии, которая будет должна остаться на платформе

    }

    function stopVoting(uint index) external {
        require(
        now >= votings[index].endsAt 
        && !votings[index].started // не нужно останавливать голосования, которые еще не начались
        && !votings[index].ended // не нужно останавливать голосвания, которые уже закончились
        && index // есть ли такой индекс в массиве
        );
        votings[index].ended = true;
        withDrawAll(); // отрпавить все бабки победителю (withdraw)
        

    }


    function vote(uint index, address candidate) external payable {
        // мне нужно добавить в мапинг партисипант адрес того кто и за кого
        // существуют ли такой кандидат и голосвание. активно ли оно
        // если патипант уже есть, пошел в жопу
        require(msg.value == 0.01Eth);
        votings[index].participants[msg.sender] = candidate;

    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _
    };
}