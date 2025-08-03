// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();
error FundMe__InsufficientETH();
error FundMe__TransactionFailed();

contract FundMe {
    using PriceConverter for uint256;


    uint256 public constant MINIMUM_USD = 5e18;
    address[] public s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        if(msg.value.getConversionRate() < MINIMUM_USD){
            revert FundMe__InsufficientETH();
        }
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public OnlyOwner {
        for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        if(!callSuccess){
            revert FundMe__TransactionFailed();
        }
    }

       modifier OnlyOwner(){
        if(msg.sender != i_owner){
            revert FundMe__NotOwner();
        }
        _;
    } 

    fallback() external payable { 
        fund();
    } 
    receive() external payable {
        fund();
     } 
}