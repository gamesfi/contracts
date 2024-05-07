const chalk = require('chalk')
const hre = require("hardhat");

async function main() {
    const gamesFiNFTContract = await hre.ethers.getContractFactory("GamesFi_NFT");

    const gamesFiNFT = await gamesFiNFTContract.deploy();
    console.log(chalk.bgGreen(chalk.bold("GamesFi NFT: ", gamesFiNFT.address)))

    if (hre.network.name === "hardhat") {
        return;
    }
    console.info(chalk.bgBlue("Waiting For Explorer to Sync Contract (10s)..."))
    await wait(10)

    try {
        await hre.run("verify:verify", {
            address: gamesFiNFT.address,
            contract: "contracts/erc721/GamesFi_NFT.sol:GamesFi_NFT",
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
