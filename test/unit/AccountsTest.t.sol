// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Accounts} from "../../contracts/Accounts.sol";
import {DeployAccounts} from "../../script/DeployAccounts.s.sol";
import {USDC} from "../../contracts/mocks/MockUSDC.sol";
import {Test, console} from "forge-std/Test.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract AccountsTest is Test {
    Accounts accounts;
    USDC usdc;
    address USER = makeAddr("USER");

    function setUp() external {
        usdc = new USDC();

        DeployAccounts deployAccounts = new DeployAccounts(usdc.getContractAddress());
        accounts = deployAccounts.run();

        vm.deal(USER, 1 ether);
    }

    function testOpeningAccount() public {
        vm.prank(USER);
        accounts.openAccount();

        assertEq(accounts.getPoints(USER), 10);
        assertEq(accounts.getCreditLimit(USER), 1000);
    }
}
