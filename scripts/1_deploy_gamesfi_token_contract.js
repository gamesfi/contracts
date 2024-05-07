const chalk = require('chalk')
const hre = require("hardhat");

async function main() {
    const gamesFiTokenContract = await hre.ethers.getContractFactory("GamesFi_Token");

    const gamesFiToken = await gamesFiTokenContract.deploy();
    console.log(chalk.bgGreen(chalk.bold("GamesFi Token: ", gamesFiToken.address)))

    if (hre.network.name === "hardhat") {
        return;
    }
    console.info(chalk.bgBlue("Waiting For Explorer to Sync Contract (10s)..."))
    await wait(10)

    try {
        await hre.run("verify:verify", {
            address: gamesFiToken.address,
            contract: "contracts/erc20/GamesFi_Token.sol:GamesFi_Token",
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
