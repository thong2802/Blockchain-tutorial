import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {},
    bsc_testnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey : process.env.ETHERSCAN_API_KEY
  }
};


