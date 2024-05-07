const chalk = require('chalk')
const hre = require("hardhat");

async function main() {
    const gamesFiTokenContract = '0xC078cB6cC9B962f25482DA5D7D18d3cF849CAFc8'
    const GamesFiLotteryContract = await hre.ethers.getContractFactory("GamesFiLottery");

    const gamesFiLottery = await GamesFiLotteryContract.deploy(gamesFiTokenContract);
    console.log(chalk.bgGreen(chalk.bold("GamesFi Lottery: ", gamesFiLottery.address)))

    if (hre.network.name === "hardhat") {
        return;
    }
    console.info(chalk.bgBlue("Waiting For Explorer to Sync Contract (10s)..."))
    await wait(10)

    try {
        await hre.run("verify:verify", {
            address: gamesFiLottery.address,
            contract: "contracts/lottery/GamesFiLottery.sol:GamesFiLottery",
            constructorArguments: [gamesFiTokenContract],
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

