pragma solidity 0.6.10;

interface IPortfolioFactory {
    function getAllowedTokens() external view returns (address[] memory);
}