//SPDX-License-Identifier: MIT                                                                                                 
/* ***************************************************************************************************/                                     
/*                                                          dddddddd                                 */
/* KKKKKKKKK    KKKKKKK  iiii                               d::::::dlllllll                          */
/* K:::::::K    K:::::K i::::i                              d::::::dl:::::l                          */
/* K:::::::K    K:::::K  iiii                               d::::::dl:::::l                          */
/* K:::::::K   K::::::K                                     d:::::d l:::::l                          */
/* KK::::::K  K:::::KKKiiiiiiinnnn  nnnnnnnn        ddddddddd:::::d  l::::lyyyyyyy           yyyyyyy */
/*  K:::::K K:::::K   i:::::in:::nn::::::::nn    dd::::::::::::::d  l::::l y:::::y         y:::::y   */
/*   K::::::K:::::K     i::::in::::::::::::::nn  d::::::::::::::::d  l::::l  y:::::y       y:::::y   */
/*   K:::::::::::K      i::::inn:::::::::::::::nd:::::::ddddd:::::d  l::::l   y:::::y     y:::::y    */
/*   K:::::::::::K      i::::i  n:::::nnnn:::::nd::::::d    d:::::d  l::::l    y:::::y   y:::::y     */
/*   K::::::K:::::K     i::::i  n::::n    n::::nd:::::d     d:::::d  l::::l     y:::::y y:::::y      */
/*   K:::::K K:::::K    i::::i  n::::n    n::::nd:::::d     d:::::d  l::::l      y:::::y:::::y       */
/* KK::::::K  K:::::KKK i::::i  n::::n    n::::nd:::::d     d:::::d  l::::l       y:::::::::y        */
/* K:::::::K   K::::::Ki::::::i n::::n    n::::nd::::::ddddd::::::ddl::::::l       y:::::::y         */
/* K:::::::K    K:::::Ki::::::i n::::n    n::::n d:::::::::::::::::dl::::::l        y:::::y          */
/* K:::::::K    K:::::Ki::::::i n::::n    n::::n  d:::::::::ddd::::dl::::::l       y:::::y           */
/* KKKKKKKKK    KKKKKKKiiiiiiii nnnnnn    nnnnnn   ddddddddd   dddddllllllll      y:::::y            */
/*                                                                              y:::::y              */
/*                                                                             y:::::y               */
/*                                                                           y:::::y                 */
/*                                                                          y:::::y                  */
/*                                                                          yyyyyyy                  */
/*****************************************************************************************************/

pragma solidity ^0.8.0;

/**
 * @dev Interface to verify ONG on the factory
 */
interface IFactory {
    function verifyProof(bytes32[] calldata _merkleProof) external view returns (bool);
}

contract Particular {

    address public admin;
    uint256 public percent;
    address public ong;
    address public factory;
    address public wallet;

constructor (address _admin, uint256 _percent, address _ong, address _factory, address _wallet) {
    admin = _admin;
    percent = _percent;
    ong = _ong;
    factory = _factory;
    wallet = _wallet;
}
/**
 * @dev splitts the money automaticly between the ONG and the wallet which will receive the rest
 */
receive() external payable {
    uint256 tocharity = msg.value * percent / 100;
    uint256 towallet = msg.value - tocharity;
    (bool success, ) = ong.call{value: tocharity}("");
    require(success, "Error: money could not be sended to ONG");
    (success, ) = wallet.call{value: towallet}("");
    require(success, "Error: money could not be sended to wallet");
}
/**
 * @dev setters
 */
function setAdmin(address _admin) virtual public onlyAdmin {
    require(admin != _admin, "Error, admin already setted");
    admin = _admin;
}

function setONG(address _ong, bytes32[] calldata _proof) virtual public onlyAdmin {
    require(ong != _ong, "Error: ong already setted");
    require(checkVerifyedONG(_proof) == true, "Error: non verified ONG");
    ong = _ong;
}

function setPercent(uint256 _percent) virtual public onlyAdmin {
    require(_percent != percent, "Error: same percent");
    percent = _percent;
}

function setWallet(address _wallet) virtual public onlyAdmin {
    require(wallet != _wallet, "Error: wallet already setted");
    wallet = _wallet;
}
/**
 * @dev check if the ONG is verifyed on the factory
 */
function checkVerifyedONG(bytes32[] calldata _proof) public view returns (bool) {
    bool success = IFactory(factory).verifyProof(_proof);
    require(success, "Error: not verified ONG");
    return success;
}

modifier onlyAdmin {
    require(admin == msg.sender, "Error, only admin can call this function");
    _;
}
}