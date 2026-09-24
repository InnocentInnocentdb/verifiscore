// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {VerifiScore} from "../src/VerifiScore.sol";

contract VerifiScoreScript is Script {
    VerifiScore public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new VerifiScore();

        vm.stopBroadcast();
    }
}
