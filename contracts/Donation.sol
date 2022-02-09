// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract Donation is Ownable {
    mapping (address => uint) benefactors;
    event Received(address, uint);

    constructor() payable {}

    receive() external payable {
        benefactors[msg.sender] += msg.value;
        emit Received(msg.sender, msg.value);
    }

    fallback() external payable {
        benefactors[msg.sender] += msg.value;
        emit Received(msg.sender, msg.value);
    }

    function withdraw(address payable _to) external onlyOwner {
        uint amount = address(this).balance;
        (bool success, ) = _to.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function shutdown() external onlyOwner {
        selfdestruct(payable(owner));
    }
}
