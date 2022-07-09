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

import "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Particular.sol";

contract Factory is Initializable {

    address public admin;
    bytes32 public seed;
    mapping(address => Particular) public Registry;

/**
 * @dev Constructor
 */
function initialize(address _admin, bytes32 _seed) virtual public initializer {
    admin = _admin;
    seed = _seed;
}
/**
 * @dev Create a new Particular contract for a user
 */
function createParticular(uint256 _percent, address _ong, address _wallet) virtual public {
    Particular particular = new Particular(msg.sender, _percent, _ong, address(this), _wallet);
    Registry[msg.sender] = particular;
}
/**
 * @dev  admin setter
 */
function setAdmin(address _admin) virtual public onlyAdmin {
    require(admin != _admin, "Error: admin already setted");
    admin = _admin;
}
/**
 * @dev seed setter
 */
function setSeed(bytes32 _seed) virtual public onlyAdmin {
    require(seed != _seed, "Error: Merkle seed already setted");
    seed = _seed;
}
/**
 * @dev verify ONG address on a merkle seed
 */ 
function verifyProof(bytes32[] calldata _merkleProof) virtual public view returns (bool) {
    return (MerkleProofUpgradeable.verify(_merkleProof, seed, keccak256(abi.encodePacked(msg.sender))));
}

modifier onlyAdmin {
    require(admin == msg.sender, "Error: only admin can call this function");
    _;
}

}