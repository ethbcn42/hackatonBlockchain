import { expect } from "chai";
import { ethers } from "hardhat";

const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const hre = require('hardhat');

describe("WhiteList mint testing", function () {

    let logic : any;
    let signers : any;
    let instance : any;
    let instanceNotOwner : any;

    let whiteList = [
        "0x143Ee9c8c36BBF9AAE54c68f05d4CA11d805420B",
        "0x8D2b33989f0B17Bc110f301EAB47c791629FA128",
        "0x3D78DC0605ecFD2FF25f2fec9741691D19824812",
        "0x009805716c9DC414E7fE71A4B264E32BB80268C6",
        "0xfA1e95e226cef05A135e04e08eBC60Eb7bEa0143",
        "0x307181285538917c1e200675965D3461Ae7fd596",
        "0xE9598FAA6fC246DBf81C56e2bE6cf9Ee2536596d",
        "0x3195298fcFe9772aC77aA9865E7e8072C51938bf",
        "0xF0a9b6973B10406FF73615Ca7f1C36E967624F4A",
        "0x743aE4428De6D4d9F4f1f84CDbBC2A20a70Db3C4",
        "0x6B7d03B1273Cbf60823d4E05632a2415c398A389",
        "0x80085E036647c9FBe30803d944cb0311464F8636",
        "0xAD53Fc82cC6bd1447FcDf66e6A85DAABC0440343",
        "0x1d7bD68dcC3e2766846CBDf83E9CEEC422c36Bd0",
        "0xa1E7241F2c8D02Acb18fc17259E88253B7e023b7",
        "0x0b15B6192Cc82A6f7BBE945E249Edaca3E7Edde4",
        "0x446bb02a2f21b395B166765A73cC54Bc7BB0a7EE",
        "0xD3f4370F33627840C54361823971Ace0D433Be1e",
        "0x19E2fDc9b06E36b691Cc08BaC531eEBF0ac15164",
        "0xad77a20752D0cD9c7de6a5C82Dc2885a5ED1621B"
    ]

    const leafNodes = whiteList.map(address => keccak256(address));
    const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
    const rootHash = merkleTree.getRoot();
    console.log(rootHash);
    //console.log(merkleTree.toString());
    const proof = merkleTree.getHexProof(keccak256("0x143Ee9c8c36BBF9AAE54c68f05d4CA11d805420B"));
    console.log(proof);

    before (async () => {
        signers = await ethers.getSigners();
    });

    this.beforeAll(async function() {
        const Logic = await hre.ethers.getContractFactory("Factory");
        logic = await Logic.deploy();
        await logic.deployed();
        instance = await logic.connect(signers[0]);
        instanceNotOwner = await logic.connect(signers[1]);
        await instance.initialize(signers[0].getAddress(), rootHash);
    });

    it("should test WL works fine", async function () {
        expect( await instance.verifyProof(proof, "0x143Ee9c8c36BBF9AAE54c68f05d4CA11d805420B")).to.be.true;
        expect( await instanceNotOwner.verifyProof(proof, "0xF410D6069f76F3ccF035D397E28dF3E90A82885D")).to.be.false;
    });

});