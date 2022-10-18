
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../ERC20Permit/TokenERC20Permit.sol";


contract ContractPermit{
    TokenERC20Permit public immutable token;
    constructor(address _token) {
        token = TokenERC20Permit(_token);
    }

    // event
    event Deposit(address indexed owner, uint amount);
    event DepositWithPermit(address indexed owner, address indexed spender, uint amount);

    function deposit(uint amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount);
    }

    function depositWithPermit(address owner, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        token.permit(owner, address(this), amount, deadline, v, r, s);
        token.transferFrom(owner, address(this), amount);
        emit DepositWithPermit(owner, address(this), amount);
    }

}
