//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeETH is Ownable {
    address public tokenAddress;

    mapping(address => uint256) public pendingBalances;

    constructor(IERC20 _tokenAddress) Ownable(msg.sender) {
        require(address(_tokenAddress) != address(0), "Invalid address");
        require(
            isERC20(address(_tokenAddress)),
            "Not a valid ERC-20 token address"
        );
        tokenAddress = address(_tokenAddress);
    }

    // Function to check if the address implements ERC-20
    function isERC20(address _addr) internal view returns (bool) {
        try IERC20(_addr).totalSupply() returns (uint256) {
            return true;
        } catch {
            return false;
        }
    }

    function deposit(IERC20 _tokenAddress, uint256 _amount) public {
        require(
            tokenAddress == address(_tokenAddress),
            "Invalid token address"
        );

        require(
            _tokenAddress.allowance(msg.sender, address(this)) >= _amount,
            "Check the token allowance"
        );

        require(
            _tokenAddress.transferFrom(msg.sender, address(this), _amount),
            "Transfer failed"
        );

        pendingBalances[msg.sender] += _amount;
        console.log("Token deposited successfully");
    }

    function withdraw(IERC20 _tokenAddress, uint256 _amount) public {
        require(pendingBalances[msg.sender] >= _amount, "Insufficient balance");

        pendingBalances[msg.sender] -= _amount;
        _tokenAddress.transfer(msg.sender, _amount);
    }
}

/*
- BridgeEth is lock the token 
- When necessary , the owner can unlock the token

--Process--
1. User deposit token in BridgeETH
2. BridgeEth contract lock the token 
3. Only owner can unlock the token


*/
