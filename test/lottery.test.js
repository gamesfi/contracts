// const { ethers } = require("hardhat");
// const { assert, expect } = require("chai");
// const {  expectEvent, } = require("@openzeppelin/test-helpers");
// const {parseEther} = require("ethers/lib/utils");
// const {BigNumber} = require("ethers");
// const wait = require("./helpers/wait");
// describe("Lottery Contract Tests", function () {
//     // We define a fixture to reuse the same setup in every test.
//     // We use loadFixture to run this setup once, snapshot that state,
//     // and reset Hardhat Network to that snapshot in every test.
//
//     // VARIABLES
//     const _totalInitSupply = ethers.utils.parseEther("10000");
//     let _lengthLottery = BigNumber.from("5"); // 4h
//     let _priceTicketInCake = ethers.utils.parseEther("0.5");
//     let _discountDivisor = "2000";
//     let _rewardsBreakdown = ["200", "300", "500", "1500", "2500", "5000"];
//     let _treasuryFee = "2000";
//
//
//     // Generic variables
//     let result;
//     let endTime;
//
//     let alice, bob, carol, david, erin, operator, treasury, injector
//     let mockToken, lottery
//
//     beforeEach(async () => {
//         [alice, bob, carol, david, erin, operator, treasury, injector] = await ethers.getSigners();
//         const MockERC20 = await ethers.getContractFactory("MockERC20");
//
//         // Deploy MockToken
//         mockToken = await MockERC20.deploy("Mock GSCORE", "GSCORE", _totalInitSupply);
//         const GamesFiLottery = await ethers.getContractFactory("GamesFiLottery");
//
//         // Deploy Lottery
//         lottery = await GamesFiLottery.deploy(mockToken.address);
//
//     });
//
//
//     describe("Lottery Flow Tests", function () {
//
//
//
//         it("Admin sets up treasury/operator address", async () => {
//
//             result = await lottery.connect(alice).setOperatorAndTreasuryAndInjectorAddresses(operator.address, treasury.address, injector.address);
//             let receipt = await result.wait();
//             let event = receipt.events.find((x) => x.event === "NewOperatorAndTreasuryAndInjectorAddresses");
//
//             assert.isDefined(event);
//             assert.equal(event.args.operator, operator.address);
//
//             for (let thisUser of [alice, bob, carol, david, erin, injector]) {
//                 await mockToken.connect(thisUser).mintTokens( parseEther("100000"));
//                 await mockToken.connect(thisUser).approve(lottery.address, parseEther("100000"), );
//             }
//
//
//             const blockNumber = await ethers.provider.getBlockNumber();
//             const block = await ethers.provider.getBlock(blockNumber);
//             console.log("Current Block Time in Seconds:", block.timestamp);
//             endTime = BigNumber.from(block.timestamp).add(_lengthLottery);
//
//
//             result = await lottery.connect(operator).startLottery(
//                 endTime,
//                 _priceTicketInCake,
//                 _discountDivisor,
//                 _rewardsBreakdown,
//                 _treasuryFee
//             );
//
//              receipt = await result.wait();
//              event = receipt.events.find((x) => x.event === "LotteryOpen");
//
//             assert.isDefined(event);
//             console.log(event.args);
//             assert.equal(event.args.priceTicketInGScore, _priceTicketInCake.toString());
//
//
//             // Purchase Test
//
//             const _ticketsBought = [
//                 "1234561",
//                 "1234562",
//                 "1234563",
//                 "1234564",
//                 "1234565",
//                 "1234566",
//                 "1234567",
//                 "1234568",
//                 "1234569",
//                 "1234570",
//                 "1334571",
//                 "1334572",
//                 "1334573",
//                 "1334574",
//                 "1334575",
//                 "1334576",
//                 "1334577",
//                 "1334578",
//                 "1334579",
//                 "1334580",
//                 "1434581",
//                 "1434582",
//                 "1434583",
//                 "1434584",
//                 "1434585",
//                 "1434586",
//                 "1434587",
//                 "1434588",
//                 "1434589",
//                 "1534590",
//                 "1534591",
//                 "1534592",
//                 "1534593",
//                 "1534594",
//                 "1534595",
//                 "1534596",
//                 "1534597",
//                 "1534598",
//                 "1534599",
//                 "1634600",
//                 "1634601",
//                 "1634602",
//                 "1634603",
//                 "1634604",
//                 "1634605",
//                 "1634606",
//                 "1634607",
//                 "1634608",
//                 "1634609",
//                 "1634610",
//                 "1634611",
//                 "1634612",
//                 "1634613",
//                 "1634614",
//                 "1634615",
//                 "1634616",
//                 "1634617",
//                 "1634618",
//                 "1634619",
//                 "1634620",
//                 "1634621",
//                 "1634622",
//                 "1634623",
//                 "1634624",
//                 "1634625",
//                 "1634626",
//                 "1634627",
//                 "1634628",
//                 "1634629",
//                 "1634630",
//                 "1634631",
//                 "1634632",
//                 "1634633",
//                 "1634634",
//                 "1634635",
//                 "1634636",
//                 "1634637",
//                 "1634638",
//                 "1634639",
//                 "1634640",
//                 "1634641",
//                 "1634642",
//                 "1634643",
//                 "1634644",
//                 "1634645",
//                 "1634646",
//                 "1634647",
//                 "1634648",
//                 "1634649",
//                 "1634650",
//                 "1634651",
//                 "1634652",
//                 "1634653",
//                 "1634654",
//                 "1634655",
//                 "1634656",
//                 "1634657",
//                 "1634658",
//                 "1634659",
//                 "1634660",
//             ];
//
//             result = await lottery.connect(bob).buyTickets("1", _ticketsBought);
//             receipt = await result.wait();
//             event = receipt.events.find((x) => x.event === "TicketsPurchase");
//
//             assert.isDefined(event);
//
//             assert.equal(event.args.numberTickets, "100");
//             expectEvent.inTransaction(receipt.transactionHash, mockToken, "Transfer", {
//                 from: bob.address,
//                 to: lottery.address,
//                 value: parseEther("47.525").toString(),
//             });
//
//
//             result = await lottery.viewLottery("1");
//             assert.equal(result[11].toString(), parseEther("47.525").toString());
//
//             result = await lottery.viewUserInfoForLotteryId(bob.address, "1", 0, 100);
//             const bobTicketIds = [];
//             result[0].forEach(function (value) {
//                 bobTicketIds.push(value.toString());
//             });
//
//             const expectedTicketIds = Array.from({ length: 100 }, (_, v) => v.toString());
//             assert.includeOrderedMembers(bobTicketIds, expectedTicketIds);
//
//
//             result = await lottery.viewNumbersAndStatusesForTicketIds(bobTicketIds);
//             assert.includeOrderedMembers(result[0].map(String), _ticketsBought);
//
//
//             // Injection of token
//             result = await lottery.connect(alice).injectFunds("1", parseEther("10000"));
//
//             receipt = await result.wait();
//
//             event = receipt.events.find((x) => x.event === "LotteryInjection");
//
//             assert.isDefined(event);
//
//             assert.equal(event.args.injectedAmount, parseEther("10000").toString());
//             expectEvent.inTransaction(receipt.transactionHash, mockToken, "Transfer", {
//                 from: alice,
//                 to: lottery.address,
//                 value: parseEther("10000").toString(),
//             });
//
//             console.log("waiting for lottery to end")
//             await wait(5);
//             console.log("lottery ended")
//
//             // Now closing testing
//
//             result = await lottery.connect(operator).closeLottery("1");
//
//             receipt = await result.wait();
//
//             event = receipt.events.find((x) => x.event === "LotteryClose");
//
//             assert.isDefined(event);
//
//             // draw result
//             result = await lottery.connect(operator).drawFinalNumberAndMakeLotteryClaimable("1", true, 1);
//             receipt = await result.wait();
//             event = receipt.events.find((x) => x.event === "LotteryNumberDrawn");
//             assert.isDefined(event);
//         });
//     });
//
//
// });
//
