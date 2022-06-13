// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 totalWaves;

    //event creation to listen for the info of every new wave
    event NewWave(address indexed from, uint256 timestamp, string message);

    //new structure creation named Wave. This is to customize how we store our data
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Wave[] waves;

    constructor() payable { //payable is a function that allows me to send ether to the contract
        console.log("I AM SMART CONTRACT. POG.");
    }

    /*
     * Changes on the previous wave function, now
     * it requires a string called _message. This is the message our user
     * sends us from the frontend!
     */
    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);


        //This is where I actually store the wave data in the array(Wave[]).
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * I emit the 'NewWave' event so that the client can
         * see the transaction at the front-end
         */
        emit NewWave(msg.sender, block.timestamp, _message);

        uint256 prizeAmount = 0.0001 ether;

        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more than the contract has"
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract"); //Here I am checking if the withdrawl was successful, if not the message will be displayed.
    }

    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }
}