// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
        players.push(payable(manager));
    }
    
    receive() payable external  {
    	require (msg.sender != manager);
    	require (msg.value >= .01 ether);

    	players.push(payable(msg.sender));
    }
    
    function pickWinner() public restricted {
        uint indexOfWinner = random() % players.length;
        address payable winner = players[indexOfWinner];
        uint balance = address(this).balance;

        winner.transfer((balance * 10) / 100);
        payable(manager).transfer((balance * 90) / 100);

        players = new address payable[](0);
        players.push(payable(manager));
    } 
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
    
    modifier restricted() {
        require(players.length >=10 || msg.sender == manager);
        _;
    }
    
}