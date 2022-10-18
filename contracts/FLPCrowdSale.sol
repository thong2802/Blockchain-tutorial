// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";   
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract FLPCrowdSale is Ownable {
    using SafeERC20 for IERC20;
    address payable public _wallet;
    uint256 public BNB_rate;
    uint256 public USDT_rate;
    IERC20 public token;
    IERC20 public usdtToken;

    event BuyTokenByBNB(address buyer, uint256 amount, uint when);
    event BuyTokenByUSDT(address buyer, uint256 amount, uint when);
    event SetUSDTToken(IERC20 tokenAddres, uint when);
    event SetBNBRate(uint256 newRate, uint when);
    event SetUSDTRate(uint256 newRate, uint when);

    constructor(
        uint256 bnb_rate,
        uint256 usdt_rate,
        address payable wallet,
        IERC20 icoToken
    ) {
        BNB_rate = bnb_rate;
        USDT_rate = usdt_rate;
        _wallet = wallet;
        token = icoToken;
    }

    function setUSDTToken(IERC20 token_address) public onlyOwner {
        usdtToken = token_address;
        emit SetUSDTToken(token_address, block.timestamp);
    }

    function setBNBRateToken(uint256 new_rate) public onlyOwner {
        BNB_rate = new_rate;
        emit SetBNBRate(new_rate, block.timestamp);
    }

    function setUSDTRateToken(uint256 new_rate) public onlyOwner {
        USDT_rate = new_rate;
        emit SetUSDTRate(new_rate, block.timestamp);
    }

    function buyTokenByBNB() external payable{
        uint256 bnbAmount = msg.value;
        uint256 amount = getTokenAmountBNB(bnbAmount);
        require(amount >0, "Zero token");
        require(
            token.balanceOf(address(this)) >= amount, 
            "Insufficient account balance"
        );
        require(
            msg.sender.balance >= bnbAmount, 
            "Insufficient account balance"
        );
        payable(_wallet).transfer(bnbAmount);
        SafeERC20.safeTransfer(token, msg.sender, amount);
        emit BuyTokenByBNB(msg.sender, amount, block.timestamp);
    }

    function buyTokenByUSDT(uint USDTAmount) external payable{
        uint256 amount = getTokenAmountUSDT(USDTAmount);
        require(
            msg.sender.balance >= USDTAmount, 
            "Insufficient account balance"
        );
        require(
            token.balanceOf(address(this)) >= amount, 
            "Insufficient account balance"
        );
        require(amount > 0, "Zero token");
        SafeERC20.safeTransferFrom(usdtToken, msg.sender, _wallet, USDTAmount);
        SafeERC20.safeTransfer(token, msg.sender ,amount);
        emit BuyTokenByUSDT(msg.sender, amount, block.timestamp);
    }

    function getTokenAmountBNB(uint256 amount) public view returns(uint256) {
        return amount * BNB_rate;
    }

    function getTokenAmountUSDT(uint256 amount) public view returns(uint256) {
        return amount * USDT_rate;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
    function withdrawERC20() public onlyOwner {
        usdtToken.transfer(msg.sender, usdtToken.balanceOf(address(this)));
    }
}