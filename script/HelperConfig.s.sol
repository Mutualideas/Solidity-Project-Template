// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

//Function
// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address acress different chains

//Chainlink Sepolia ETH/USD address:
//Chainlink Mainnet ETH/USD address:

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // If only locat anvil, deploy mock
    // Else, grab existing address from live net

    // Variable which direct towards the appropriate Config
    NetworkConfig public activeNetworkConfig;

    constructor() {
        // Sepolia ChainID - 11155111
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
    }
}
