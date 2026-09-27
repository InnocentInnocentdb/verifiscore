// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {VerifiScore} from "../src/VerifiScore.sol";

contract DeployScript is Script {
    function run() external returns (VerifiScore) {
        vm.startBroadcast();
        VerifiScore verifiScore = new VerifiScore();
        vm.stopBroadcast();
        return verifiScore;
    }
}
