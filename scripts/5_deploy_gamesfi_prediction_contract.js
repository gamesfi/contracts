const chalk = require('chalk')
const hre = require("hardhat");
const {parseEther} = require("ethers/lib/utils");

async function main() {

    const  gamesFiToken = '0xC078cB6cC9B962f25482DA5D7D18d3cF849CAFc8'
    const pythOracleAddress = '0xA2aa501b19aff244D90cc15a4Cf739D2725B5729'
    const adminAddress = '0x0175CA8a5f3009f153d5E8d9121dd5bad6fBE205'
    const _operatorAddress = '0x0175CA8a5f3009f153d5E8d9121dd5bad6fBE205'
    const _intervalSeconds = 900 //
    const _bufferSeconds = 10
    const _minBetAmount = parseEther("1")
    const _oracleUpdateAllowance = 60
    const _treasuryFee = 200
    const _priceId = '0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43'
    const GamesFiPredictionContract = await hre.ethers.getContractFactory("GamesFiPrediction");

    const gamesFiLottery = await GamesFiPredictionContract.deploy(gamesFiToken, pythOracleAddress, adminAddress, _operatorAddress, _intervalSeconds, _bufferSeconds, _minBetAmount, _oracleUpdateAllowance, _treasuryFee, _priceId);
    console.log(chalk.bgGreen(chalk.bold("GamesFi Prediction: ", gamesFiLottery.address)))

    if (hre.network.name === "hardhat") {
        return;
    }
    console.info(chalk.bgBlue("Waiting For Explorer to Sync Contract (10s)..."))
    await wait(10)

    try {
        await hre.run("verify:verify", {
            address: gamesFiLottery.address,
            contract: "contracts/prediction/GamesFiPrediction.sol:GamesFiPrediction",
            constructorArguments: [gamesFiToken, pythOracleAddress, adminAddress, _operatorAddress, _intervalSeconds, _bufferSeconds, _minBetAmount, _oracleUpdateAllowance, _treasuryFee, _priceId],
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

