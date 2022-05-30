
pragma solidity 0.6.10;
pragma experimental "ABIEncoderV2";


import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IPortfolio } from "../interfaces/IPortfolio.sol";


contract PortfolioViewer {

    struct PortfolioDetails {
        string name;
        string symbol;
        address manager;
        address[] modules;
        IPortfolio.ModuleState[] moduleStatuses;
        IPortfolio.Position[] positions;
        uint256 totalSupply;
    }

    function batchFetchManagers(
        IPortfolio[] memory _portfolios
    )
        external
        view
        returns (address[] memory) 
    {
        address[] memory managers = new address[](_portfolios.length);

        for (uint256 i = 0; i < _portfolios.length; i++) {
            managers[i] = _portfolios[i].manager();
        }
        return managers;
    }

    function batchFetchModuleStates(
        IPortfolio[] memory _portfolios,
        address[] calldata _modules
    )
        public
        view
        returns (IPortfolio.ModuleState[][] memory)
    {
        IPortfolio.ModuleState[][] memory states = new IPortfolio.ModuleState[][](_portfolios.length);
        for (uint256 i = 0; i < _portfolios.length; i++) {
            IPortfolio.ModuleState[] memory moduleStates = new IPortfolio.ModuleState[](_modules.length);
            for (uint256 j = 0; j < _modules.length; j++) {
                moduleStates[j] = _portfolios[i].moduleStates(_modules[j]);
            }
            states[i] = moduleStates;
        }
        return states;
    }

    function batchFetchDetails(
        IPortfolio[] memory _portfolios,
        address[] calldata _moduleList
    )
        public
        view
        returns (PortfolioDetails[] memory)
    {
        IPortfolio.ModuleState[][] memory moduleStates = batchFetchModuleStates(_portfolios, _moduleList);

        PortfolioDetails[] memory details = new PortfolioDetails[](_portfolios.length);
        for (uint256 i = 0; i < _portfolios.length; i++) {
            IPortfolio portfolio = _portfolios[i];

            details[i] = PortfolioDetails({
                name: ERC20(address(portfolio)).name(),
                symbol: ERC20(address(portfolio)).symbol(),
                manager: portfolio.manager(),
                modules: portfolio.getModules(),
                moduleStatuses: moduleStates[i],
                positions: portfolio.getPositions(),
                totalSupply: portfolio.totalSupply()
            });
        }
        return details;
    }

    function getPortfolioDetails(
        IPortfolio _portfolio,
        address[] calldata _moduleList
    )
        external
        view
        returns(PortfolioDetails memory)
    {
        IPortfolio[] memory portfolioAddressForBatchFetch = new IPortfolio[](1);
        portfolioAddressForBatchFetch[0] = _portfolio;

        return batchFetchDetails(portfolioAddressForBatchFetch, _moduleList)[0];
    }
}