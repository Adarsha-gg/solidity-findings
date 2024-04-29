// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// mocks and contract addresses
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockv3agri.sol";

contract HelperConfig is Script{
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE =2000e8;
    struct NetworkConfig{
        address priceFeed; //Eth price feed
    }
    constructor(){
        if (block.chainid == 11155111)
        {
            activeNetworkConfig = getSepoEthConfig();
        }
        else if (block.chainid == 1)
        {
            activeNetworkConfig = getMainNetEthConfig();
        }
        else{
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainNetEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory mainNetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainNetConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory){
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig(address(mockPriceFeed));
        return anvilConfig;
    }
}