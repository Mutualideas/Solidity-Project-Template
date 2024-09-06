// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    //type & variable_name declared
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    modifier funded() {
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    //Setup runs first
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() external view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // Expect the next line to revert
        fundMe.fund(); //send 0 value
    }

    function testFundUpdatesFundedDataStructure() public funded {
        uint256 ammountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(ammountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanoWithdraw() public funded {
        vm.expectRevert(); // Expect the next line to revert (ignores vm calls)
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.withdraw();
    }

    function testSingleFunderWithdrawal() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        // uint256 gasStart = gasleft(); // gasleft() is a built in solidity function to get the remaining amount of gas for the current transaction
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; // gasprice is a built in solidity function to get the current gas price
        // console.log(gasUsed);

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundmeBalance = address(fundMe).balance;
        assertEq(endingFundmeBalance, 0);
        assertEq(
            (startingFundMeBalance + startingOwnerBalance),
            endingOwnerBalance
        );
    }

    function testMultipleFunderWithdrawal() public funded {
        // Arrange
        uint160 numberOfFunders = 10; // uint160 is required to generate addresses from an interger
        uint160 startingFunderIndex = 1; // Sometimes 0 reverts, so best to test with 1
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // hoax includes both vm.prank & vm.deal
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner()); // Alternative methods for vm.prank for multiple lines
        fundMe.withdraw();
        vm.stopPrank(); // Alternative methods for vm.prank for multiple lines

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
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
