// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {VerifiScore} from "../src/VerifiScore.sol";

contract VerifiScoreTest is Test {
    VerifiScore public verifiScore;
    address public studentWallet = address(0x123);
    address public lecturerWallet = address(0x789);

    function setUp() public {
        verifiScore = new VerifiScore();
        verifiScore.registerStudent("MAT/2020/001", studentWallet);
        verifiScore.addLecturer(lecturerWallet);
    }

    function test_RegisterStudent() public {
        assertEq(verifiScore.matricToWallet("MAT/2020/001"), studentWallet);
    }

    function test_RevertWhen_DuplicateMatric() public {
        vm.expectRevert("Matric number already registered");
        verifiScore.registerStudent("MAT/2020/001", address(0x456));
    }

    function test_RevertWhen_NotOwner() public {
        vm.prank(address(0x999));
        vm.expectRevert();
        verifiScore.registerStudent("MAT/2020/002", address(0x999));
    }

    function test_SubmitScore() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 18);

        (uint256 score, bool submitted, bool acknowledged) =
            verifiScore.getScore(studentWallet, "PLB301", "Practical1");

        assertEq(score, 18);
        assertTrue(submitted);
        assertFalse(acknowledged);
    }

    function test_RevertWhen_NotAuthorizedLecturer() public {
        vm.prank(address(0x999));
        vm.expectRevert("Not an authorized lecturer");
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 18);
    }

    function test_RevertWhen_StudentNotRegistered() public {
        vm.prank(lecturerWallet);
        vm.expectRevert("Student not registered");
        verifiScore.submitScore("MAT/9999/999", "PLB301", "Practical1", 18);
    }
}
