require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  networks: {
    avalanche: {
      url: API_URL,
      chainId: 2000777,
      gasPrice: 225000000000,
      accounts: [PRIVATE_KEY],
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.1",
        settings: {},
      },
    ],
  },
};