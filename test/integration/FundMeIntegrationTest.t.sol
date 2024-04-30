// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFund} from "../../Script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract IntegrationTest is Test{
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant MONI =  0.2 ether;
    uint256 constant balance =  1 ether;
    uint256 constant gas =  1 ;
    
    function setUp() external  {
        DeployFund deploy = new DeployFund();
        fundMe = deploy.run();
        vm.deal(USER, balance);
    }

    function testUser() public{
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe =  new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}