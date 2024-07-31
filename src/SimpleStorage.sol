// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {
    uint256 myFavoriteNumber;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

// - Simple Storage: https://www.cookbook.dev/contracts/remix-simple-storage-f23-SimpleStorage
// - Storage Factory: https://www.cookbook.dev/protocols/remix-storage-factory-f23
// - Fund Me: https://www.cookbook.dev/contracts/remix-fund-me-f23-FundMe
// - Foundry Simple Storage: https://www.cookbook.dev/protocols/foundry-simple-storage-f23
// - Foundry Fund Me: https://www.cookbook.dev/protocols/foundry-fund-me-f23
// - Smart Contract Lottery: https://www.cookbook.dev/protocols/foundry-smart-contract-lottery-f23
// - ERC20: https://www.cookbook.dev/protocols/foundry-erc20-f23
// - NFT: https://www.cookbook.dev/protocols/foundry-nft-f23
// - Stablecoin: https://www.cookbook.dev/protocols/foundry-defi-stablecoin-f23
// - Upgrades: https://www.cookbook.dev/protocols/foundry-upgrades-f23
// - DAO: https://www.cookbook.dev/protocols/foundry-dao-f23
// - Security: https://www.cookbook.dev/protocols/denver-security
