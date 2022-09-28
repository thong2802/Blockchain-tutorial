// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

/**
 *@title contact Vault
 *@author Lonan Nguyen
 */
contract Vault is  Ownable, AccessControlEnumerable {
    IERC20 private token;
    uint256 public maxWithdrawAmount; // maximum amount user can withdraw;
    bool public withdrawEnable; // button turn on or off user can withdraw;
    bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER_ROLE");


    // even
    event Withdrawal( uint256 amount, address to, uint when);
    event deposited(uint256 amount, uint when);
    // modifier
    modifier onlyWithDrawer() {
        require(
            owner() == _msgSender() || hasRole(WITHDRAWER_ROLE, _msgSender()),
            "caller is not a withdraw");
        _;
    }

    function setWithDrawEnable(bool _isEnable) public onlyOwner {
        withdrawEnable = _isEnable;
    }

    function setMaxWithDrawAmount(uint256 _amount) public onlyOwner { 
        maxWithdrawAmount = _amount;
    }

    function setToken(IERC20 _token) public onlyOwner {
        token = _token; 
    }

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function withdraw(
        uint256 _amount,
        address _to
    ) external onlyWithDrawer {
        require(withdrawEnable, "Withdraw is not available");
        require(_amount <= maxWithdrawAmount, "Exceed maxinum amount");
        token.transfer(_to, _amount);
        emit Withdrawal(_amount, _to, block.timestamp);
    }

    function deposit(uint256 _amount) external {
        require(
            token.balanceOf(msg.sender) >= _amount,
            "Insufficient accounts balance"
        );
        SafeERC20.safeTransferFrom(token, msg.sender, address(this), _amount);
        emit deposited(_amount, block.timestamp);
    }

    function getMaxWithdrawAmount() external view returns(uint256) {
        return maxWithdrawAmount;
    }

    function getWithdrawEnable() external view returns(bool) {
        return withdrawEnable;
    }
    
    

}