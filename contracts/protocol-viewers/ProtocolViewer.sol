
pragma solidity 0.6.10;
pragma experimental "ABIEncoderV2";


import { ERC20Viewer } from "./ERC20Viewer.sol";
import { PortfolioViewer } from "./PortfolioViewer.sol";

contract ProtocolViewer is
    ERC20Viewer,
    PortfolioViewer
{
    constructor() public {}
}