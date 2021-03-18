import { HardhatUserConfig } from "hardhat/types";
import "@nomiclabs/hardhat-waffle";
import "hardhat-typechain";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      { version: "0.7.5", settings: {} }, // for DePay
      { version: "0.5.16", settings: {} }, // for Uniswap
      { version: "0.6.0", settings: {} }, // for StakingPool
      { version: "0.6.2", settings: {} }, // for StakingPool
      { version: "0.6.6", settings: {} }, // for Uniswap
      { version: "0.6.12", settings: {} }, // for StakingPool
      { version: "0.4.18", settings: {} } // for WETH
    ],
  }
};

export default config;
