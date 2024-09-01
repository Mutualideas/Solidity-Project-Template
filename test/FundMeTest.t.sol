// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    //type & variable_name declared

    //Setup runs first
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() external view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }
}

// Notes:

// Types of tests

// 1.  Unit
//     - Testing a part of the the code
// 2.  Integration
//     - Testing how the code works with other parts of the codebase
// 3.  Forked
//     - Testing the code on a simulated real environment
// 4.  Staging
//     - Testing the code in a real environment that is not prod

//$forge coverage
//$forge coverage --fork-url $SEPOLIA_RPC_URL
//^see testing coverage
