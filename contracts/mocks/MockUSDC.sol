// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract USDC is ERC20 {
    uint256 public constant USDC_SUPPLY = 1000;
    address public s_contractAddress;

    constructor() ERC20("USDC", "USDC") {
        s_contractAddress = address(this);
    }

    function mint(address _to) public {
        _mint(_to, USDC_SUPPLY);
    }

    function getContractAddress() external view returns (address) {
        return s_contractAddress;
    }
}
