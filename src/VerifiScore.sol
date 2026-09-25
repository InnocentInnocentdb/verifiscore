// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract VerifiScore is Ownable {
    mapping(string => address) public matricToWallet;
    mapping(address => string) public walletToMatric;

    event StudentRegistered(string matricNumber, address indexed wallet);

    constructor() Ownable(msg.sender) {}

    function registerStudent(string calldata matricNumber, address studentWallet) external onlyOwner {
        require(studentWallet != address(0), "Invalid wallet address");
        require(matricToWallet[matricNumber] == address(0), "Matric number already registered");
        require(bytes(walletToMatric[studentWallet]).length == 0, "Wallet already registered");

        matricToWallet[matricNumber] = studentWallet;
        walletToMatric[studentWallet] = matricNumber;

        emit StudentRegistered(matricNumber, studentWallet);
    }
}
