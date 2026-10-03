// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ClientRegistry} from "./ClientRegistry.sol"; 

contract MyBank {

    address internal transferToAddress;
    ClientRegistry public myClientRegistry;

    error NotOwner();
    error NotSufficientBalance();
    error TransactionFail();
    error ClientNotRegistered();
    error AddressCantFind();

        myClientRegistry.updateAccountBalance (_accountNumber, checkAccountBalance(_accountNumber) - _withdrawAmount);
        (bool success, ) = payable(msg.sender).call{value: _withdrawAmount}("");                
        if ( !success) revert TransactionFail();
    }

    function transfer (uint256 _toAccountNumber, uint256 _transferAmount) external {
        address _toAccountAddress = searchArrAccNumForAdd(_toAccountNumber);
        uint256 _accountNumber = searchArrAddForAccNum(msg.sender);

        if (_toAccountAddress == address(0)) revert ClientNotRegistered();
        if (_transferAmount > checkAccountBalance(_accountNumber)) revert NotSufficientBalance();

        myClientRegistry.updateAccountBalance(_accountNumber, checkAccountBalance(_accountNumber) - _transferAmount);
        myClientRegistry.updateAccountBalance(_toAccountNumber, checkAccountBalance(_toAccountNumber) + _transferAmount);        
        (bool success,) = payable(_toAccountAddress).call{value: _transferAmount}("");
        if (!success) revert TransactionFail();
    }

    function searchArrAccNumForAdd (uint256 _searchAccountNumber) public view returns(address){
            for (uint256 i = 0; i < myClientRegistry.getArrLen(); i++){
                (address _clientAddress, uint256 _clientAccountNumber,,,) = myClientRegistry.clientDatabase(i);

                if ( _searchAccountNumber == _clientAccountNumber){
                    return _clientAddress;                            
                }
           }
            return address(0);            
    }

    function searchArrAddForAccNum (address _searchAddress) public view returns (uint256){
        for (uint256 i = 0; i < myClientRegistry.getArrLen(); i++){
            (address _clientAddress, uint256 _clientAccountNumber,,,) = myClientRegistry.clientDatabase(i);
                
                if (_searchAddress == _clientAddress){
                    return _clientAccountNumber;
                }
            }
        return 0;
    }


    function checkAccountBalance (uint256 _searchClientAccNum) public view returns (uint256){
        for (uint256 i = 0 ; i < myClientRegistry.getArrLen(); i++){
            (,uint256 _clientAccNum,,,uint256 _balance) = myClientRegistry.clientDatabase(i);

                if (_searchClientAccNum == _clientAccNum){
                    return _balance;
                }
            }
        revert ClientNotRegistered();
    }


    receive() external payable {
        emit logReceiveData (msg.sender, msg.value);
    }

    fallback() external payable {
        emit logFallbackData (msg.sender, msg.value, msg.data);
    }

}
