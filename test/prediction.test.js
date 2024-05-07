const { ethers } = require("hardhat");
const { assert, expect } = require("chai");
const {  expectEvent, BN, } = require("@openzeppelin/test-helpers");
const {parseEther} = require("ethers/lib/utils");
const {BigNumber} = require("ethers");
const wait = require("./helpers/wait");
const { EvmPriceServiceConnection } = require("@pythnetwork/pyth-evm-js");
const chalk = require('chalk')

describe("Prediction Contract Tests", function () {
    const btcPriceId = '0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43'
    let owner, bob, carol, david, erin, operator, treasury, injector;
    let mockPyth, mockToken, prediction;

    const _intervalSeconds = 1 // interval in seconds between two prediction round
    const _bufferSeconds = 1 // number of seconds for valid execution of a prediction round
    const _minBetAmount = parseEther("0.1") // minimum bet amount
    const _oracleUpdateAllowance = 60 // seconds before the oracle can be updated
    const _treasuryFee = 200 // treasury rate (e.g. 200 = 2%, 150 = 1.50%)
    beforeEach(async () => {
        [owner, bob, carol, david, erin, operator, treasury, injector] = await ethers.getSigners();
        // Deploy MockToken
        const MockERC20 = await ethers.getContractFactory("MockERC20");
        mockToken = await MockERC20.deploy("Mock GSCORE", "GSCORE", ethers.utils.parseEther("10000"));


        console.log(chalk.bgGreen(chalk.bold("MockToken: ", mockToken.address)))
        // Deploy MockOracle
        const MockOracle = await ethers.getContractFactory("MockPyth");
        mockPyth = await MockOracle.deploy();
        console.log(chalk.bgGreen(chalk.bold("MockOracle: ", mockPyth.address)))

        // Deploy PredictionContract
        const GamesFiPredictionContract = await ethers.getContractFactory("GamesFiPrediction");
        prediction = await GamesFiPredictionContract.deploy(mockToken.address, mockPyth.address, owner.address, operator.address, _intervalSeconds, _bufferSeconds, _minBetAmount, _oracleUpdateAllowance, _treasuryFee, btcPriceId);
        console.log(chalk.bgGreen(chalk.bold("GamesFi Prediction: ", prediction.address)))

        // Set Operator and Treasury
        await prediction.connect(owner).setOperator(operator.address);
        await prediction.connect(owner).setAdmin(treasury.address);

        // Mint Tokens and approval to prediction contract
        mockToken.connect(bob).mintTokens(ethers.utils.parseEther("100000"));
        mockToken.connect(carol).mintTokens(ethers.utils.parseEther("100000"));
        mockToken.connect(david).mintTokens(ethers.utils.parseEther("100000"));
        mockToken.connect(erin).mintTokens(ethers.utils.parseEther("100000"));

        mockToken.connect(bob).approve(prediction.address, ethers.utils.parseEther("100000"));
        mockToken.connect(carol).approve(prediction.address, ethers.utils.parseEther("100000"));
        mockToken.connect(david).approve(prediction.address, ethers.utils.parseEther("100000"));
        mockToken.connect(erin).approve(prediction.address, ethers.utils.parseEther("100000"));

    });


    describe("Prediction Flow Tests", function () {

        it("Should start genesis rounds (round 1, round 2, round 3)", async () => {
            const connection = new EvmPriceServiceConnection("https://hermes.pyth.network");
            const priceIds = ["0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43"]
            const priceFeedUpdateData = await connection.getPriceFeedsUpdateData(
                priceIds
            );
            await mockPyth.updatePriceFeeds(priceFeedUpdateData);
            // Epoch 1: Start genesis round 1
            let currentTimestamp = await prediction.currentTimestamp();

            let tx = await prediction.connect(operator).genesisStartRound();
            let receipt = await tx.wait();

            let event = receipt.events.find((x) => x.event === "StartRound");

            assert.isDefined(event);
            assert.equal(event.args.epoch, "1");
            assert.equal(await prediction.currentEpoch(), 1);

            // Start round 1
            assert.equal(await prediction.genesisStartOnce(), true);
            assert.equal(await prediction.genesisLockOnce(), false);
            assert.equal((await prediction.rounds(1)).epoch, 1);
            assert.equal((await prediction.rounds(1)).totalAmount, 0);

            await wait(1)

            tx = await prediction.connect(operator).genesisLockRound();

            await wait(1)

            await prediction.connect(operator).updatePythOracle(priceFeedUpdateData, { value: parseEther("1.1") });
            tx = await prediction.connect(operator).executeRound();
            // receipt = await tx.wait();
            //
            // event = receipt.events.find((x) => x.event === "StartRound");
            //
            // assert.isDefined(event);
            // assert.equal(event.args.epoch, "2");
            // assert.equal(await prediction.currentEpoch(), 2);

        });
    });


});

