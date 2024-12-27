//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {BridgeETH} from "src/BridgeETH.sol";
import {USDT} from "src/USDT.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeEth is Test {
    BridgeETH bridgeEth;
    USDT usdt;

    function setUp() public {
        usdt = new USDT();
        bridgeEth = new BridgeETH(address(usdt));
    }

    function testDeposit() public {
        usdt.mint(0x2966473D85A76A190697B5b9b66b769436EFE8e5, 200);
        vm.startPrank(0x2966473D85A76A190697B5b9b66b769436EFE8e5);

        usdt.approve(address(bridgeEth), 200);

        bridgeEth.deposit(usdt, 200);

        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5), 0);

        assertEq(usdt.balanceOf(address(bridgeEth)), 200);

        assertEq(
            bridgeEth.pendingBalances(
                0x2966473D85A76A190697B5b9b66b769436EFE8e5
            ),
            200
        );
    }

    function testWithdraw() public {
        usdt.mint(0x2966473D85A76A190697B5b9b66b769436EFE8e5, 200);
        vm.startPrank(0x2966473D85A76A190697B5b9b66b769436EFE8e5);

        usdt.approve(address(bridgeEth), 200);

        bridgeEth.deposit(usdt, 200);

        bridgeEth.withdraw(usdt, 200);
        assertEq(bridgeEth.pendingBalances(address(this)), 0);
    }

    // function test_Deposit() public {
    //     usdt.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 200);
    //     vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    //     usdt.approve(address(bridgeEth), 200);

    //     bridgeEth.deposit(usdt, 200);
    //     assertEq(usdt.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 0);
    //     assertEq(usdt.balanceOf(address(bridgeEth)), 200);

    //     bridgeEth.withdraw(usdt, 100);

    //     assertEq(
    //         usdt.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
    //         100
    //     );
    //     assertEq(usdt.balanceOf(address(bridgeEth)), 100);
    // }
}
