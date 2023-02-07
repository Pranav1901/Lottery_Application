//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager; //who can control all the transactions 
    address payable[] public participants;  // a dyanmic array for the participants
    
    constructor(){
        manager=msg.sender; //global variable
    }

    receive() external payable{
        require(msg.value>=0.001 ether);   // a minimum value to enter into lottery
        participants.push(payable(msg.sender));   // if the value paid by the participant is greater than 0.001 ether then only he is added to the array
    }
    // a function to check balance of the contract which can only be accessed by the manager 
    function getBalance() public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    }
    
    // a function to generate random number to randomly choose from participants from the participants array.
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));

    }
    
    // a function for choosing the participant and transfering the amount to winners account.
    function selectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = random();
        uint index =  r % participants.length;
        address payable winner = participants[index];
        winner.transfer(getBalance()); 
        participants = new address payable[](0);
    }
}
