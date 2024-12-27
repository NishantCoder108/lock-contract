//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract USDT is ERC20, Ownable {
    constructor() ERC20("USDT", "USDT") Ownable(msg.sender) {
        // _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}
