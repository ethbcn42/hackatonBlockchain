import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import { boolean, string } from "hardhat/internal/core/params/argumentTypes";
import { NetworkUserConfig } from "hardhat/types";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.12",
  networks: {
    hardhat: {
    },
    polygon: {
      url: " https://polygon-rpc.com",
      accounts: process.env.PRIVATE_KEY != undefined ? [process.env.PRIVATE_KEY]:[]
    },
    ethereum: {
      url: "https://mainnet.infura.io/v3/a7a3d44c2ed340f2b0a3bfde0588ec47",
      accounts: process.env.PRIVATE_KEY != undefined ? [process.env.PRIVATE_KEY]:[]
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: process.env.PRIVATE_KEY != undefined ? [process.env.PRIVATE_KEY]:[]
    },
    goerli: {
      url: "https://goerli.infura.io/v3/a7a3d44c2ed340f2b0a3bfde0588ec47",
      accounts: process.env.PRIVATE_KEY != undefined ? [process.env.PRIVATE_KEY]:[]
    },
    neonlabs: <NetworkUserConfig> {
      url: 'https://proxy.devnet.neonlabs.org/solana',
      accounts: [process.env.PRIVATE_KEY],
      network_id: 245022926,
      chainId: 245022926,
      gas: 66665460,
      gasPrice: 166481678000,
      blockGasLimit: 10000000,
      allowUnlimitedContractSize: false,
      timeout: 1000000,
      isFork: true
    }
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "EUR",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  paths: {
    sources: "./src/contracts",
    tests: "./test"
  }
};

export default config;
