// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenERC20Permit is ERC20, ERC20Permit{
    constructor() ERC20Permit("Token") ERC20("Token", "DAL"){}

    function mint(address _to, uint _amount) external {
        _mint(_to, _amount);
    }
}