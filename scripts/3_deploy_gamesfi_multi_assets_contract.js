const chalk = require('chalk')
const hre = require("hardhat");

async function main() {
    const GamesFi_MultiAsset_Contract = await hre.ethers.getContractFactory("GamesFi_MultiAsset");

    const gamesFiMultiAsset = await GamesFi_MultiAsset_Contract.deploy();
    console.log(chalk.bgGreen(chalk.bold("GamesFi Multi Asset: ", gamesFiMultiAsset.address)))

    if (hre.network.name === "hardhat") {
        return;
    }
    console.info(chalk.bgBlue("Waiting For Explorer to Sync Contract (10s)..."))
    await wait(10)

    try {
        await hre.run("verify:verify", {
            address: gamesFiMultiAsset.address,
            contract: "contracts/erc1155/GamesFi_MultiAssets.sol:GamesFi_MultiAsset",
            constructorArguments: [],
        });
    } catch (error) {
        console.log("Verification Failed.: ", error);
    }
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

async function wait(timeInSeconds) {
    await new Promise((r) => setTimeout(r, timeInSeconds * 1000));
}

