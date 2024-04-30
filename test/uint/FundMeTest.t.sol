// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFund} from "../../Script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fuu;
    address USER = makeAddr("adu");
    uint256 constant moni = 2 ether;

    function setUp() external {
        DeployFund deployer = new DeployFund();
        fuu = deployer.run();
        vm.deal(USER, 50 ether);
    }

    function testMin() public view {
        assertEq(fuu.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        console.log(msg.sender);
        console.log(fuu.i_owner()); // print them out
        assertEq(fuu.i_owner(), msg.sender); // test to see if its the same
    }

    function testPrice() public view {
        uint256 version = fuu.getVersion();
        assertEq(version, 4); // check if same version
    }

    function testEthFails() public {
        vm.expectRevert();
        fuu.fund(); // send 0 eth which is less than minimum amount so hopefully it reverts
        //if not then theres an compilation error
    }

    function testPranks() public {
        vm.startPrank(USER); // this is to specify who sends the transaction.
        fuu.fund{value: moni}(); // send ehter with transaction
        uint256 amount = fuu.addressToAmountFunded(USER);
        assertEq(amount, moni); // this compiles because > Minimum amount
        vm.stopPrank();
    }

    function testFundertoArray() public {
        vm.prank(USER);
        fuu.fund{value: moni}();

        address funder = fuu.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded(){
        vm.prank(USER);
        fuu.fund{value:moni}();
        _;
    }

    function testOwnerWithdraw() public funded() {
        vm.prank(USER);
        vm.expectRevert();
        fuu.withdraw();
    }

    function testWithOwner() public funded(){
        uint256 balance = fuu.getOwner().balance;
        uint256 contractBalance = address(fuu).balance;

        vm.prank(fuu.getOwner()); // prank used to change the address kinda
        fuu.withdraw();

        uint256 afterWithdraw = fuu.getOwner().balance;
        uint256 afterContractBalance = address(fuu).balance;
        assertEq(afterContractBalance,0);
        

    
    }
}
