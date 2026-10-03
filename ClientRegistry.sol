//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {PriceConversion} from "./PriceConversion.sol";

interface ClientRegistryFunction {
        function clientRegistry() external view returns (address);
        function getArrLen() external view returns (uint256);
    }

contract ClientRegistry {
    using PriceConversion for uint256;

    struct Client {
        address clientAddress;
        uint256 clientAccountNumber;
        string clientName;
        string clientIC;
        uint256 balance;
    }

    mapping (address => bool) IsClientRegistered ;
    Client[] public clientDatabase;
    address public owner ;
    uint256 public clientAccountNumber;
    uint256 internal openAccountMinimumDeposit = 5;
    address public priceConverteraddress ;

    error   ClientRegistered();
    error   MinimumFirstDepostAmount5USD();
    error   ClientNotRegistered();
    error   TransactionFail();
    error   NotOwner();

    constructor () {
        owner = msg.sender;
        clientDatabase.push(Client(msg.sender, 10001, "Bank Owner", "9009", 0));
        IsClientRegistered[msg.sender] = true;
        clientAccountNumber = 10002;
    }

    function registerClient(string memory _clientName, string memory _clientIC) external payable {
        if (address(msg.sender) == owner) revert ClientRegistered();
        if (IsClientRegistered[msg.sender] == true) revert ClientRegistered();
        if (msg.value.getPriceConvert() < openAccountMinimumDeposit) revert MinimumFirstDepostAmount5USD();
        IsClientRegistered[msg.sender] = true;
        clientDatabase.push(Client(msg.sender, clientAccountNumber, _clientName, _clientIC, msg.value));                
        clientAccountNumber ++;
    }

    function checkClientRegistrationDetails(uint256 _clientAccountNumber) external view returns(Client memory) {
        for (uint i = 0; i < clientDatabase.length ; i++){
            if (clientDatabase[i].clientAccountNumber == _clientAccountNumber){
                return clientDatabase[i];
            }
        }
        revert ClientNotRegistered();
    } 

    function getClientRegistryAddress() external view returns (address){
        return address(this);
    }

    function updateAccountBalance (uint256 _accountNumber, uint256 _newBalance) public {
        for (uint i = 0; i < clientDatabase.length; i++){
            if (clientDatabase[i].clientAccountNumber == _accountNumber ){
                clientDatabase[i].balance = _newBalance;
            }
        }
    }

    function getArrLen() external view returns (uint256){
        return clientDatabase.length;
    }

    function getClientAccountBalance (uint256 _accountNumber) public view returns(uint256){
        for (uint256 i = 0; i < clientDatabase.length ; i++){
                if (clientDatabase[i].clientAccountNumber == _accountNumber){
                    return clientDatabase[i].balance ;
                }
        }
        revert ClientNotRegistered();
    }

    function checkLiquidity () public view returns (uint256){
        return address(this).balance;
    }

    function transferLiquidity (address _otherBankAddress, uint256 _transferLiquidityAmount) public{
        if (msg.sender != owner ) revert NotOwner();
        (bool success,) = payable(_otherBankAddress).call {value: _transferLiquidityAmount}(""); 
        if (!success) revert TransactionFail();
    }

}
