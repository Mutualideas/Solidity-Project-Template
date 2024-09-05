// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

//Function
// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address acress different chains

//Chainlink Sepolia ETH/USD address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
//Chainlink Mainnet ETH/USD address: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If only locat anvil, deploy mock
    // Else, grab existing address from live net

    // Variable which direct towards the appropriate Config
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        // Sepolia ChainID - 11155111
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        // Eth Mainnet ChainID - 1
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // 1. Deploy the mocks
        vm.startBroadcast();
        // 2. Return the mock address
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
