
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "../contracts/Proxy.sol";
import "../contracts/Particular.sol";
import "../contracts/Factory.sol";

interface CheatCodes {
    function prank(address _from) external;
    function expectRevert(bytes calldata) external;
    function startPrank(address) external;
    function stopPrank() external;
    function assume(bool) external;
    function deal(address,uint256) external;
}

contract Test is DSTest {

    Proxy proxy;
    Factory factory;
    Particular particular;
    address public deployer = 0xF410D6069f76F3ccF035D397E28dF3E90A82885D;
    address public whitelisted = 0x143Ee9c8c36BBF9AAE54c68f05d4CA11d805420B;
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    constructor () {
        cheats.startPrank(deployer);
        factory = new Factory();
        proxy = new Proxy(address(factory), deployer, 0x4abc2edb296e6b3e26bf35d8f3839102aed2c6f4656386482459f8b9bcc166c4);
        factory.initialize(deployer, 0x4abc2edb296e6b3e26bf35d8f3839102aed2c6f4656386482459f8b9bcc166c4);
        cheats.stopPrank();
    }

    /*
     * ProxyTests
     */
    function testProxy_setLogic_notAdmin(address _address) public {
        cheats.expectRevert(bytes("you're not the proxy admin"));
        cheats.prank(_address);
        proxy.setLogicContract(_address);
    }
    function testProxy_setAdmin_notAdmin(address _address) public {
        cheats.expectRevert(bytes("you're not the proxy admin"));
        cheats.prank(_address);
        proxy.setProxyAdmin(_address);
    }
    function testProxy_setLogic_admin(address _address) public {
        cheats.prank(deployer);
        proxy.setLogicContract(_address);
        assertEq(proxy.implementation(), _address);
    }
    function testProxy_setAdmin_admin(address _address) public {
        cheats.prank(deployer);
        proxy.setProxyAdmin(_address);
        assertEq(proxy.proxyAdmin(), _address);
    }

}