// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {VerifiScore} from "../src/VerifiScore.sol";

contract VerifiScoreTest is Test {
    VerifiScore public verifiScore;
    address public studentWallet = address(0x123);

    function setUp() public {
        verifiScore = new VerifiScore();
    }

    function test_RegisterStudent() public {
        verifiScore.registerStudent("MAT/2020/001", studentWallet);
        assertEq(verifiScore.matricToWallet("MAT/2020/001"), studentWallet);
    }

    function test_RevertWhen_DuplicateMatric() public {
        verifiScore.registerStudent("MAT/2020/001", studentWallet);
        vm.expectRevert("Matric number already registered");
        verifiScore.registerStudent("MAT/2020/001", address(0x456));
    }

    function test_RevertWhen_NotOwner() public {
        vm.prank(address(0x999));
        vm.expectRevert();
        verifiScore.registerStudent("MAT/2020/001", studentWallet);
    }
}
