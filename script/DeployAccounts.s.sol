// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Accounts} from "../contracts/Accounts.sol";

contract DeployAccounts is Script {
    address[] private s_whitelistedTokenAddresses;

    constructor(address[] memory _whitelistedTokenAddresses) {
        s_whitelistedTokenAddresses = _whitelistedTokenAddresses;
    }

    function run() external returns (Accounts) {
        vm.startBroadcast();
        Accounts deployAccounts = new Accounts(s_whitelistedTokenAddresses);
        vm.stopBroadcast();

        return deployAccounts;
    }
}
