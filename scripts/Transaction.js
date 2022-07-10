// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Logic = await hre.ethers.getContractFactory("Factory");
  const Proxy = await hre.ethers.getContractFactory("Proxy");
  const Particular = await hre.ethers.getContractFactory("Particular");

  const instance = Logic.attach("0x16F1860C543f2f5D82A3c27B2E956cB4A924f0f1")
  await instance.createParticular(20, "0x143Ee9c8c36BBF9AAE54c68f05d4CA11d805420B", "0xF410D6069f76F3ccF035D397E28dF3E90A82885D")
  let particularAddress = await instance.Registry("0xF410D6069f76F3ccF035D397E28dF3E90A82885D")
  const particular =  Particular.attach(particularAddress)
  console.log(particularAddress)
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });