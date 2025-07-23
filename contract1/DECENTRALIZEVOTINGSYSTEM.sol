// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Project {
    address public admin;
    bool public electionStarted;
    uint public totalVotes;

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier electionOngoing() {
        require(electionStarted, "Election is not started");
        _;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        require(!electionStarted, "Can't add candidates after election starts");
        candidates.push(Candidate(_name, 0));
    }

    function startElection() public onlyAdmin {
        require(!electionStarted, "Election already started");
        electionStarted = true;
    }

    function vote(uint _candidateIndex) public electionOngoing {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        candidates[_candidateIndex].voteCount++;
        hasVoted[msg.sender] = true;
        totalVotes++;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function endElection() public onlyAdmin {
        require(electionStarted, "Election not started");
        electionStarted = false;
    }

    // Function to get election winner
    function getWinner() public view returns (string memory winnerName, uint winnerVoteCount) {
        require(!electionStarted, "Election is still ongoing");
        require(candidates.length > 0, "No candidates available");

        uint highestVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        winnerName = candidates[winnerIndex].name;
        winnerVoteCount = candidates[winnerIndex].voteCount;
    }

    // Function to check if an address has voted
    function getVoterStatus(address _voter) public view returns (bool) {
        return hasVoted[_voter];
    }
}
