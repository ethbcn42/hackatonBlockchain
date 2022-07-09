// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
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

  const logic = await Logic.deploy();
  await logic.deployed();
  console.log("Logic deployed to:", logic.address);

  const proxy = await Proxy.deploy(logic.address, "0xF410D6069f76F3ccF035D397E28dF3E90A82885D", "0x4abc2edb296e6b3e26bf35d8f3839102aed2c6f4656386482459f8b9bcc166c4");
  await proxy.deployed();
  console.log("Proxy deployed (and initialized) to:", proxy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });