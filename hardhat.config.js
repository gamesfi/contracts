require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

var global = {}
const fs = require("fs");

function prepareConfig() {
    // expected config path
    const configPath = `${__dirname}/deployment_config.js`;

    // create dummy object if deployment config doesn't exist
    // for compilation purposes
    if (fs.existsSync(configPath)) {
        global.DeploymentConfig = require(configPath);
    } else {
        global.DeploymentConfig = {};
    }
}
prepareConfig();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
 defaultNetwork: "hardhat",
  networks: {
      hardhat: {
          gas: 120000000,
          blockGasLimit: 0x1fffffffffffff,
      },
    bttc_testnet: {
        chainId: 1029,
        url: global.DeploymentConfig.bttc_testnet.rpc,
        accounts: [
            `${global.DeploymentConfig.bttc_testnet.mnemonic}`,
        ],
        loggingEnabled: true,
        throwOnTransactionFailures: true,
    },
    bttc_mainnet: {
        chainId: 199,
        url: global.DeploymentConfig.bttc_mainnet.rpc,
        accounts: [
            `${global.DeploymentConfig.bttc_mainnet.mnemonic}`,
        ],
        loggingEnabled: true,
        throwOnTransactionFailures: true,
    },
  },
    etherscan: {
        apiKey: {
            bttc_testnet: process.env.BTTC_TEST_EXPLORER,
            bttc_mainnet: process.env.BTTC_MAIN_EXPLORER,
        },
        customChains: [
            {
                network: "bttc_testnet",
                chainId: 1029,
                urls: {
                    apiURL: "https://api-testnet.bttcscan.com/api",
                    browserURL: "https://testnet.bttcscan.com"
                }
            },
            {
                network: "bttc_mainnet",
                chainId: 199,
                urls: {
                    apiURL: "https://api.bttcscan.com/api",
                    browserURL: "https://bttcscan.com"
                }
            }
        ]
    },
    allowUnlimitedContractSize: true,
}
