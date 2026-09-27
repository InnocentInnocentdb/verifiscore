// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract VerifiScore is Ownable {
    mapping(string => address) public matricToWallet;
    mapping(address => string) public walletToMatric;
    mapping(address => bool) public authorizedLecturers;

    struct ScoreEntry {
        uint256 score;
        bool submitted;
        bool acknowledged;
    }

    struct Correction {
        uint256 newScore;
        string reason;
        uint256 timestamp;
    }

    mapping(address => mapping(string => mapping(string => ScoreEntry))) private studentScores;
    mapping(address => mapping(string => mapping(string => Correction[]))) private scoreCorrections;

    event StudentRegistered(string matricNumber, address indexed wallet);
    event LecturerAuthorized(address indexed lecturer);
    event ScoreSubmitted(string matricNumber, string courseCode, string assessmentName, uint256 score);
    event ScoreAcknowledged(string matricNumber, string courseCode, string assessmentName);
    event ScoreCorrected(
        string matricNumber, string courseCode, string assessmentName, uint256 newScore, string reason
    );

    constructor() Ownable(msg.sender) {}

    modifier onlyAuthorizedLecturer() {
        require(authorizedLecturers[msg.sender], "Not an authorized lecturer");
        _;
    }

    function registerStudent(string calldata matricNumber, address studentWallet) external onlyOwner {
        require(studentWallet != address(0), "Invalid wallet address");
        require(matricToWallet[matricNumber] == address(0), "Matric number already registered");
        require(bytes(walletToMatric[studentWallet]).length == 0, "Wallet already registered");

        matricToWallet[matricNumber] = studentWallet;
        walletToMatric[studentWallet] = matricNumber;

        emit StudentRegistered(matricNumber, studentWallet);
    }

    function addLecturer(address lecturer) external onlyOwner {
        require(lecturer != address(0), "Invalid lecturer address");
        authorizedLecturers[lecturer] = true;
        emit LecturerAuthorized(lecturer);
    }

    function submitScore(
        string calldata matricNumber,
        string calldata courseCode,
        string calldata assessmentName,
        uint256 score
    ) external onlyAuthorizedLecturer {
        address studentWallet = matricToWallet[matricNumber];
        require(studentWallet != address(0), "Student not registered");
        require(!studentScores[studentWallet][courseCode][assessmentName].submitted, "Score already submitted");

        studentScores[studentWallet][courseCode][assessmentName] =
            ScoreEntry({score: score, submitted: true, acknowledged: false});

        emit ScoreSubmitted(matricNumber, courseCode, assessmentName, score);
    }

    function acknowledgeScore(string calldata courseCode, string calldata assessmentName) external {
        require(bytes(walletToMatric[msg.sender]).length != 0, "Wallet not registered as a student");

        ScoreEntry storage entry = studentScores[msg.sender][courseCode][assessmentName];
        require(entry.submitted, "No score submitted for this assessment");
        require(!entry.acknowledged, "Score already acknowledged");

        entry.acknowledged = true;

        emit ScoreAcknowledged(walletToMatric[msg.sender], courseCode, assessmentName);
    }

    function correctScore(
        string calldata matricNumber,
        string calldata courseCode,
        string calldata assessmentName,
        uint256 newScore,
        string calldata reason
    ) external onlyAuthorizedLecturer {
        address studentWallet = matricToWallet[matricNumber];
        require(studentWallet != address(0), "Student not registered");
        require(studentScores[studentWallet][courseCode][assessmentName].submitted, "No original score to correct");
        require(bytes(reason).length > 0, "A reason is required for every correction");

        scoreCorrections[studentWallet][courseCode][assessmentName].push(
            Correction({newScore: newScore, reason: reason, timestamp: block.timestamp})
        );

        emit ScoreCorrected(matricNumber, courseCode, assessmentName, newScore, reason);
    }

    function getCorrectionCount(address studentWallet, string calldata courseCode, string calldata assessmentName)
        external
        view
        returns (uint256)
    {
        return scoreCorrections[studentWallet][courseCode][assessmentName].length;
    }

    function getCorrection(
        address studentWallet,
        string calldata courseCode,
        string calldata assessmentName,
        uint256 index
    ) external view returns (uint256 newScore, string memory reason, uint256 timestamp) {
        Correction memory c = scoreCorrections[studentWallet][courseCode][assessmentName][index];
        return (c.newScore, c.reason, c.timestamp);
    }

    function getScore(address studentWallet, string calldata courseCode, string calldata assessmentName)
        external
        view
        returns (uint256 score, bool submitted, bool acknowledged)
    {
        ScoreEntry memory entry = studentScores[studentWallet][courseCode][assessmentName];
        return (entry.score, entry.submitted, entry.acknowledged);
    }

    function getFullRecord(address studentWallet, string calldata courseCode, string calldata assessmentName)
        external
        view
        returns (uint256 originalScore, bool submitted, bool acknowledged, uint256 correctionCount, uint256 latestScore)
    {
        ScoreEntry memory entry = studentScores[studentWallet][courseCode][assessmentName];
        Correction[] memory corrections = scoreCorrections[studentWallet][courseCode][assessmentName];

        uint256 finalScore = entry.score;
        if (corrections.length > 0) {
            finalScore = corrections[corrections.length - 1].newScore;
        }

        return (entry.score, entry.submitted, entry.acknowledged, corrections.length, finalScore);
    }
}
