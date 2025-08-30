    // Function to get the current leader during the election
    function getCurrentLeader() public view electionOngoing returns (string memory leaderName, uint leaderVoteCount) {
        require(candidates.length > 0, "No candidates available");

        uint highestVotes = 0;
        uint leaderIndex = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                leaderIndex = i;
            }
        }

        leaderName = candidates[leaderIndex].name;
        leaderVoteCount = candidates[leaderIndex].voteCount;
    }
