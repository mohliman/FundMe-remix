// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// get funds from users
// withdraw funds
// set a minimum funding value in USD
contract FundMe {
    uint256 public minimumUSD = 5e18;

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUSD,"Didnt send enough ETH");
    }

    // 0x694AA1769357215DE4FAC081bf1f309aDC325306 ETH/USD
    //function withdraw() public {}
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }


    
}