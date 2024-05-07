pragma solidity ^0.8.18;


/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {
	/**
	 * @dev Multiplies two unsigned integers, reverts on overflow.
     */
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
		// benefit is lost if 'b' is also tested.
		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
		if (a == 0) {
			return 0;
		}
		
		uint256 c = a * b;
		require(c / a == b);
		
		return c;
	}
	
	/**
	 * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		// Solidity only automatically asserts when dividing by 0
		require(b > 0);
		uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
		
		return c;
	}
	
	/**
	 * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b <= a);
		uint256 c = a - b;
		
		return c;
	}
	
	/**
	 * @dev Adds two unsigned integers, reverts on overflow.
     */
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a);
		
		return c;
	}
	
	/**
	 * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b != 0);
		return a % b;
	}
}

// * aureum - fair games that pay Ether. Version 1.
//
//
// * Uses hybrid commit-reveal + block hash random number generation that is immune
//   to tampering by players, house and miners. Apart from being fully transparent,
//   this also allows arbitrarily high bets.
//

contract CoinToss {
	/// *** Constants section
	
	using SafeMath for uint256;
	
	// Each bet is deducted % in favour of the house, but no less than some minimum.
	// The lower bound is dictated by gas costs of the settleBet transaction, providing
	// headroom for up to 10 Gwei prices.
	uint public HOUSE_EDGE_PERCENT = 6;
	uint public HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
	
	// There is minimum and maximum bets.
	uint public MIN_BET = 0.01 ether;
	uint public MAX_AMOUNT = 300000 ether;
	
	
	
	
	// Modulo is a number of equiprobable outcomes in a game:
	//  - 2 for coin flip
	// It's called so because 256-bit entropy is treated like a huge integer and
	// the remainder of its division by modulo is considered bet outcome.
	uint constant MAX_MODULO = 100;
	
	// For modulos below this threshold rolls are checked against a bit mask,
	// thus allowing betting on any combination of outcomes. For example, given
	// modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
	// 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
	// limit is used, allowing betting on any outcome in [0, N) range.
	//
	// The specific value is dictated by the fact that 256-bit intermediate
	// multiplication result allows implementing population count efficiently
	// for numbers that are up to 42 bits, and 40 is the highest multiple of
	// eight below 42.
	uint constant MAX_MASK_MODULO = 40;
	
	// This is a check on bet mask overflow.
	uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
	
	// EVM BLOCKHASH opcode can query no further than 256 blocks into the
	// past. Given that settleBet uses block hash of placeBet as one of
	// complementary entropy sources, we cannot process bets older than this
	// threshold. On rare occasions aureum croupier may fail to invoke
	// settleBet in this timespan due to technical issues or extreme Ethereum
	// congestion; such bets can be refunded via invoking refundBet.
	uint constant BET_EXPIRATION_BLOCKS = 250;
	
	
	// Adjustable max bet profit. Used to cap bets against dynamic odds.
	uint public maxProfit;
	
	// Accumulated jackpot fund.
	uint256 public jackpotSize;
	
	// Funds that are locked in potentially winning bets. Prevents contract from
	// committing to bets it cannot pay out.
	uint128 public lockedInBets;
	
	// A structure representing a single bet.
	struct Bet {
		// Wager amount in wei.
		uint amount;
		// Modulo of a game.
		uint8 modulo;
		// Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
		// and used instead of mask for games with modulo > MAX_MASK_MODULO.
		uint8 rollUnder;
		// Block number of placeBet tx.
		uint40 placeBlockNumber;
		// Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
		uint40 mask;
		// Address of a gambler, used to pay out winning bets.
		address payable gambler;
		
	}
	
	// Mapping from commits to all currently active & processed bets.
	mapping (uint => Bet) public bets;
	
	// Croupier account.
	address payable public croupier;
	
	// Events that are issued to make statistic recovery easier.
	event FailedPayment(address indexed beneficiary, uint amount);
	event Payment(address indexed beneficiary, uint amount);
	
	// This event is emitted in placeBet to record commit in the logs.
	event Commit(uint commit, uint winAmount);
	
	// Constructor. Deliberately does not take any parameters.
	constructor () {
		croupier = payable(msg.sender);
		maxProfit = 500 ether;
	}
	
	
	
	// Standard modifier on methods invokable only by contract owner.
	modifier onlyCroupier {
		require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
		_;
	}




/**
	 * @notice Fallback function to receive Ether
	 */
	receive() external payable {}
	
	/**
	 * @notice Fallback function to receive Ether so we can use for pyth
	 */
	fallback() external payable {}
	
	// Change the croupier address.
	function setCroupier(address payable newCroupier) external onlyCroupier {
		croupier = newCroupier;
	}
	
	// Change max bet reward. Setting this to zero effectively disables betting.
	function setMaxProfit(uint _maxProfit) public onlyCroupier {
		require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
		maxProfit = _maxProfit;
	}
	
	// This function is used to bump up the jackpot fund. Cannot be used to lower it.
	function increaseJackpot(uint increaseAmount) external onlyCroupier {
		require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
		require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
		jackpotSize += uint128(increaseAmount);
	}
	
	// Funds withdrawal to cover costs of aureum operation.
	function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyCroupier {
		require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
		require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
		sendFunds(beneficiary, withdrawAmount, withdrawAmount);
	}
	
	
	function setCoinFlipHouseEdgeMinAmount(uint newPrice) external onlyCroupier {
		HOUSE_EDGE_MINIMUM_AMOUNT = newPrice;
	}
	
	function setCoinFlipHouseEdgePercent(uint newPercent) external onlyCroupier {
		HOUSE_EDGE_PERCENT = newPercent;
	}
	
	
	function setCoinFlipMinBet(uint newPrice) external onlyCroupier {
		MIN_BET = newPrice;
	}
	
	function setCoinFlipMaxAmount(uint newPrice) external onlyCroupier {
		MAX_AMOUNT = newPrice;
	}
	
	/// *** Betting logic
	
	// Bet states:
	//  amount == 0 && gambler == 0 - 'clean' (can place a bet)
	//  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
	//  amount == 0 && gambler != 0 - 'processed' (can clean storage)
	//
	//  NOTE: Storage cleaning is not implemented in this contract version; it will be added
	//        with the next upgrade to prevent polluting Ethereum state with expired bets.
	
	// Bet placing transaction - issued by the player.
	//  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
	//                    [0, betMask) for larger modulos.
	//  modulo          - game modulo.
	//  commitLastBlock - number of the maximum block where "commit" is still considered valid.
	//  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
	//                    by the aureum croupier bot in the settleBet transaction. Supplying
	//                    "commit" ensures that "reveal" cannot be changed behind the scenes
	//                    after placeBet have been mined.
	//  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
	//                    guaranteed to always equal 27.
	//
	// Commit, being essentially random 256-bit number, is used as a unique bet identifier in
	// the 'bets' mapping.
	//
	// Commits are signed with a block limit to ensure that they are used at most once - otherwise
	// it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
	// with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
	// placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
	function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit) external payable {
		// Check that the bet is in 'clean' state.
		Bet storage bet = bets[commit];
		require (bet.gambler == address(0), "Bet should be in a 'clean' state.");
		
		// Validate input data ranges.
		uint amount = msg.value;
		//: TODO for now only coin flip so module should be only 2
		require (modulo == 2, "Modulo should be 2.");
		require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
		require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
		
		// Check that commit is valid - it has not expired and its signature is valid.
		require (block.number <= commitLastBlock, "Commit has expired.");
		
		uint rollUnder;
		uint mask;
		
		if (modulo <= MAX_MASK_MODULO) {
			// Small modulo games specify bet outcomes via bit mask.
			// rollUnder is a number of 1 bits in this mask (population count).
			// This magic looking formula is an efficient way to compute population
			// count on EVM for numbers below 2**40. For detailed proof consult
			// the aureum whitepaper.
			rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
			mask = betMask;
		} else {
			// Larger modulos specify the right edge of half-open interval of
			// winning bet outcomes.
			require (betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
			rollUnder = betMask;
		}
		
		// Winning amount increase.
		uint possibleWinAmount;
		
		(possibleWinAmount) = getDiceWinAmount(amount, modulo, rollUnder);
		
		// Enforce max profit limit.
		require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
		
		// Lock funds.
		lockedInBets += uint128(possibleWinAmount);
		
		// Check whether contract has enough funds to process this bet.
		require ( lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
		
		// Record commit in logs.
		
		// Store bet parameters on blockchain.
		bet.amount = amount;
		bet.modulo = uint8(modulo);
		bet.rollUnder = uint8(rollUnder);
		bet.placeBlockNumber = uint40(block.number);
		bet.mask = uint40(mask);
		bet.gambler = payable(msg.sender);
		
		
		uint winAmount = settleBetInternal(commit, blockhash(bet.placeBlockNumber));
		
		emit Commit(commit, winAmount);
		
	}
	
	
	// This is the method used to settle 99% of bets. To process a bet with a specific
	// "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
	// "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
	// is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
	function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
		uint commit = reveal; // uint(keccak256(abi.encodePacked(reveal)));
		
		Bet storage bet = bets[commit];
		uint placeBlockNumber = bet.placeBlockNumber;
		
		// Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
		require (blockhash(placeBlockNumber) == blockHash);
		
		// Settle bet using reveal and blockHash as entropy sources.
		settleBetCommon(bet, reveal, blockHash);
	}
	
	function settleBetInternal(uint reveal, bytes32 blockHash) internal returns (uint){
		uint commit = reveal; // uint(keccak256(abi.encodePacked(reveal)));
		
		Bet storage bet = bets[commit];
		uint placeBlockNumber = bet.placeBlockNumber;
		
		// Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
		require (blockhash(placeBlockNumber) == blockHash);
		
		// Settle bet using reveal and blockHash as entropy sources.
		uint winAmount = settleBetCommon(bet, reveal, blockHash);
		return winAmount;
	}
	
	
	// Common settlement code for settleBet.
	function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private returns (uint) {
		// Fetch bet parameters into local variables (to save gas).
		uint amount = bet.amount;
		uint modulo = bet.modulo;
		uint rollUnder = bet.rollUnder;
		address payable gambler = bet.gambler;
		
		// Check that bet is in 'active' state.
		require (amount != 0, "Bet should be in an 'active' state");
		
		// Move bet into 'processed' state already.
		bet.amount = 0;
		
		// The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
		// are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
		// preimage is intractable), and house is unable to alter the "reveal" after
		// placeBet have been mined (as Keccak256 collision finding is also intractable).
		bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
		
		// Do a roll by taking a modulo of entropy. Compute winning amount.
		uint dice = uint(entropy) % modulo;
		
		uint diceWinAmount;
		(diceWinAmount) = getDiceWinAmount(amount, modulo, rollUnder);
		
		uint diceWin = 0;
		
		// Determine dice outcome.
		if (modulo <= MAX_MASK_MODULO) {
			// For small modulo games, check the outcome against a bit mask.
			if ((2 ** dice) & bet.mask != 0) {
				diceWin = diceWinAmount;
			}
			
		} else {
			// For larger modulos, check inclusion into half-open interval.
			if (dice < rollUnder) {
				diceWin = diceWinAmount;
			}
			
		}
		
		// Unlock the bet amount, regardless of the outcome.
		lockedInBets -= uint128(diceWinAmount);
		
		// Send the funds to gambler.
		sendFunds(gambler, diceWin  == 0 ? 1 wei : diceWin, diceWin);
		
		return diceWin;
	}
	
	// Refund transaction - return the bet amount of a roll that was not processed in a
	// due timeframe. Processing such blocks is not possible due to EVM limitations (see
	// BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
	// in a situation like this, just contact the aureum support, however nothing
	// precludes you from invoking this method yourself.
	function refundBet(uint commit) external onlyCroupier {
		// Check that bet is in 'active' state.
		Bet storage bet = bets[commit];
		uint amount = bet.amount;
		
		require (amount != 0, "Bet should be in an 'active' state");
		
		// Check that bet has already expired.
		require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
		
		// Move bet into 'processed' state, release funds.
		bet.amount = 0;
		
		uint diceWinAmount;
		(diceWinAmount) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
		
		lockedInBets -= uint128(diceWinAmount);
		
		// Send the refund.
		sendFunds(bet.gambler, amount, amount);
	}
	
	// Get the expected win amount after house edge is subtracted.
	function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private view returns (uint winAmount) {
		require (0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
		
		
		uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
		
		if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
			houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
		}
		
		require (houseEdge  <= amount, "Bet doesn't even cover house edge.");
		winAmount = (amount - houseEdge ) * modulo / rollUnder;
	}
	
	// Helper routine to process the payment.
	function sendFunds(address payable beneficiary, uint amount, uint successLogAmount) private {
		if (beneficiary.send(amount)) {
			emit Payment(beneficiary, successLogAmount);
		} else {
			emit FailedPayment(beneficiary, amount);
		}
	}
	
	// This are some constants making O(1) population count in placeBet possible.
	// See whitepaper for intuition and proofs behind it.
	uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
	uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
	uint constant POPCNT_MODULO = 0x3F;
}
