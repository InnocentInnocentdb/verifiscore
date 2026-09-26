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

    function test_AcknowledgeScore() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 18);

        vm.prank(studentWallet);
        verifiScore.acknowledgeScore("PLB301", "Practical1");

        (, , bool acknowledged) = verifiScore.getScore(studentWallet, "PLB301", "Practical1");
        assertTrue(acknowledged);
    }

    function test_RevertWhen_AcknowledgingUnsubmittedScore() public {
        vm.prank(studentWallet);
        vm.expectRevert("No score submitted for this assessment");
        verifiScore.acknowledgeScore("PLB301", "Practical1");
    }

    function test_RevertWhen_DoubleAcknowledge() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 18);

        vm.prank(studentWallet);
        verifiScore.acknowledgeScore("PLB301", "Practical1");

        vm.prank(studentWallet);
        vm.expectRevert("Score already acknowledged");
        verifiScore.acknowledgeScore("PLB301", "Practical1");
    }

    function test_RevertWhen_UnregisteredWalletAcknowledges() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 18);

        vm.prank(address(0x999));
        vm.expectRevert("Wallet not registered as a student");
        verifiScore.acknowledgeScore("PLB301", "Practical1");
    }

    function test_CorrectScore_AppendsWithoutOverwriting() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 12);

        vm.prank(lecturerWallet);
        verifiScore.correctScore("MAT/2020/001", "PLB301", "Practical1", 18, "Misread handwriting on original sheet");

        (uint256 originalScore, , ) = verifiScore.getScore(studentWallet, "PLB301", "Practical1");
        assertEq(originalScore, 12, "Original score must remain untouched");

        uint256 count = verifiScore.getCorrectionCount(studentWallet, "PLB301", "Practical1");
        assertEq(count, 1);

        (uint256 newScore, string memory reason, ) =
            verifiScore.getCorrection(studentWallet, "PLB301", "Practical1", 0);
        assertEq(newScore, 18);
        assertEq(reason, "Misread handwriting on original sheet");
    }

    function test_RevertWhen_CorrectingWithoutReason() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 12);

        vm.prank(lecturerWallet);
        vm.expectRevert("A reason is required for every correction");
        verifiScore.correctScore("MAT/2020/001", "PLB301", "Practical1", 18, "");
    }

    function test_RevertWhen_CorrectingUnsubmittedScore() public {
        vm.prank(lecturerWallet);
        vm.expectRevert("No original score to correct");
        verifiScore.correctScore("MAT/2020/001", "PLB301", "Practical1", 18, "Late entry");
    }

    function test_RevertWhen_UnauthorizedCorrection() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 12);

        vm.prank(address(0x999));
        vm.expectRevert("Not an authorized lecturer");
        verifiScore.correctScore("MAT/2020/001", "PLB301", "Practical1", 18, "Attempted fraud");
    }

    function test_GetFullRecord_ReflectsLatestCorrection() public {
        vm.prank(lecturerWallet);
        verifiScore.submitScore("MAT/2020/001", "PLB301", "Practical1", 12);

        vm.prank(studentWallet);
        verifiScore.acknowledgeScore("PLB301", "Practical1");

        vm.prank(lecturerWallet);
        verifiScore.correctScore("MAT/2020/001", "PLB301", "Practical1", 18, "Misread handwriting");

        (
            uint256 originalScore,
            bool submitted,
            bool acknowledged,
            uint256 correctionCount,
            uint256 latestScore
        ) = verifiScore.getFullRecord(studentWallet, "PLB301", "Practical1");

        assertEq(originalScore, 12);
        assertTrue(submitted);
        assertTrue(acknowledged);
        assertEq(correctionCount, 1);
        assertEq(latestScore, 18);
    }
}
