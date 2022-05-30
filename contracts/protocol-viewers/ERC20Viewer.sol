pragma solidity 0.6.10;


import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ERC20Viewer {


    function batchFetchBalancesOf(
        address[] calldata _tokenAddresses,
        address[] calldata _ownerAddresses
    )
        public
        view
        returns (uint256[] memory)
    {
        uint256 addressesCount = _tokenAddresses.length;
        
        uint256[] memory balances = new uint256[](addressesCount);

        for (uint256 i = 0; i < addressesCount; i++) {
            balances[i] = ERC20(address(_tokenAddresses[i])).balanceOf(_ownerAddresses[i]);
        }

        return balances;
    }


    function batchFetchAllowances(
        address[] calldata _tokenAddresses,
        address[] calldata _ownerAddresses,
        address[] calldata _spenderAddresses
    )
        public
        view
        returns (uint256[] memory)
    {

        uint256 addressesCount = _tokenAddresses.length;
        
        
        uint256[] memory allowances = new uint256[](addressesCount);

        
        for (uint256 i = 0; i < addressesCount; i++) {
            allowances[i] = ERC20(address(_tokenAddresses[i])).allowance(_ownerAddresses[i], _spenderAddresses[i]);
        }

        return allowances;
    }
}