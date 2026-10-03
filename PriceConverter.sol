//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns (uint256){

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer * 10000000000);

    }

    function getPriceConverter (uint256 _ethAmount) public view returns(uint256){
        uint256 _ethPrice = getPrice();
        uint256 _EthAmountInUSD = _ethAmount * _ethPrice;
        return _EthAmountInUSD ;
    }

}
