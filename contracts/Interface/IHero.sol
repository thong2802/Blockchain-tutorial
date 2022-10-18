// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IHero  {
    function mint(address to, uint256 here_type) external returns(uint256);
}

