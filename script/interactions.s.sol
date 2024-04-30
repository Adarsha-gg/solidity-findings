// SPDX-Liscense-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script{
    uint256 constant MONI = 0.3 ether;

    function fundFundMe(address recent) public{
        vm.startBroadcast();
        FundMe(payable(recent)).fund{value:MONI}();
        vm.stopBroadcast();
    }
    function run() external{
        address recent = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(recent);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script{
    uint256 constant MONI = 3 ether;

    function withdrawFundMe(address recent) public{
        vm.startBroadcast();
        FundMe(payable(recent)).withdraw();
        vm.stopBroadcast();
    }
    function run() external{
        address recent = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        
        withdrawFundMe(recent);
        
    }
}