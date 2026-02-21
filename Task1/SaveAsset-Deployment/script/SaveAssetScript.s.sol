// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/SaveAsset.sol";

contract SaveAssetScript is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        // Replace with your actual constructor argument if needed
        SaveAsset saveAsset = new SaveAsset(address(0));

        vm.stopBroadcast();
    }
}