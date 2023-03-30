// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract TokenLaunchPad {
    IERC20 public tokenA;  // the address of the native token A
    IERC20 public tokenB;  // the address of the protocol token B
    address public owner;  // the address of the contract owner
    uint256 public tokenARaised;  // the amount of token A raised so far
    uint256 public tokenBTotalSupply;  // the total supply of token B
    uint256 public exchangeRate = 2;  // the exchange rate of token A to token B, set at 2% (2/100)
    
    constructor(IERC20 _tokenA, IERC20 _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        owner = msg.sender;
        tokenARaised = 10000;
        tokenBTotalSupply = 10000;
    }
    
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(tokenA.balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(tokenA.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
        
        require(tokenA.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        uint256 tokenBAmount = amount * exchangeRate / 100;
        require(tokenBAmount > 0, "Token B amount must be greater than zero");
        
        require(tokenBTotalSupply + tokenBAmount <= tokenBTotalSupply, "Insufficient token B balance");
        
        tokenBTotalSupply += tokenBAmount;
        require(tokenB.transfer(msg.sender, tokenBAmount), "Transfer failed");
        
        tokenARaised += amount;
    }
    
    function withdrawTokenA(uint256 amount) external {
        require(msg.sender == owner, "Only the owner can withdraw token A");
        require(amount > 0, "Amount must be greater than zero");
        require(tokenARaised >= amount, "Insufficient token A raised");
        
        require(tokenA.transfer(owner, amount), "Transfer failed");
        tokenARaised -= amount;
    }
    
    function withdrawTokenB(uint256 amount) external {
        require(msg.sender == owner, "Only the owner can withdraw token B");
        require(amount > 0, "Amount must be greater than zero");
        require(tokenBTotalSupply >= amount, "Insufficient token B balance");
        
        require(tokenB.transfer(owner, amount), "Transfer failed");
        tokenBTotalSupply -= amount;
    }
}
