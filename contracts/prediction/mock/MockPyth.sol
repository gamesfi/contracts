// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {IPyth}  from "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import {PythStructs} from "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

/**
 * @title MockPyth
 */
contract MockPyth is IPyth {

	uint256 value = 0;
	function getValidTimePeriod() external pure override returns (uint) {
		return 6000;
	}
	function getPrice(bytes32 id) external view override returns (PythStructs.Price memory price) {

		int64 randomNumber = int64(uint64(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id)))));
		price.price = int64(1000000 + (randomNumber % 1000000));
		price.conf = 1000000000000000000;
		price.expo = 8;
		price.publishTime = block.timestamp;
		return price;
	}
	
	function getEmaPrice(
		bytes32 id
	) external view returns (PythStructs.Price memory price) {
		int64 randomNumber = int64(uint64(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id)))));
		price.price = int64(1000000 + (randomNumber % 1000000));
		price.conf = 1000000000000000000;
		price.expo = 8;
		price.publishTime = block.timestamp;
		return price;
	}
	function getPriceUnsafe(bytes32 id) external view override returns (PythStructs.Price memory price) {
		
		int64 randomNumber = int64(uint64(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id)))));
		price.price = int64(1000000 + (randomNumber % 1000000));
		price.conf = 1000000000000000000;
		price.expo = 8;
		price.publishTime = block.timestamp;
		return price;
	}
	
	function getPriceNoOlderThan(
		bytes32 id,
		uint age
	) external view returns (PythStructs.Price memory price){
		int64 randomNumber = int64(uint64(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id, age)))));
		price.price = int64(1000000 + (randomNumber % 1000000));
		price.conf = 1000000000000000000;
		price.expo = 8;
		price.publishTime = block.timestamp;
		return price;
	}
	
	function getEmaPriceUnsafe(
		bytes32 id
	) external view returns (PythStructs.Price memory price) {
		int64 randomNumber = int64(uint64(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id)))));
		price.price = int64(1000000 + (randomNumber % 1000000));
		price.conf = 1000000000000000000;
		price.expo = 8;
		price.publishTime = block.timestamp;
		return price;
	}
	function getEmaPriceNoOlderThan(
		bytes32 id,
		uint age
	) external view returns (PythStructs.Price memory price) {
		int64 randomNumber = int64(uint64(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id, age)))));
		price.price = int64(1000000 + (randomNumber % 1000000));
		price.conf = 1000000000000000000;
		price.expo = 8;
		price.publishTime = block.timestamp;
		return price;
	}
	function updatePriceFeeds(bytes[] calldata updateData) external payable {
		value = msg.value;
	}
	
	function updatePriceFeedsIfNecessary(
		bytes[] calldata updateData,
		bytes32[] calldata priceIds,
		uint64[] calldata publishTimes
	) external payable {
		require(msg.value > 0, "Invalid Update Price");
		require(updateData.length > 0, "Invalid Update Price");
		value = msg.value;
	}
	function getUpdateFee(
		bytes[] calldata updateData
	) external pure override returns (uint feeAmount) {
		uint256 randomNumber = uint256(keccak256(abi.encodePacked(updateData[0])));
		feeAmount = 1;
	}
	
	function parsePriceFeedUpdates(
		bytes[] calldata updateData,
		bytes32[] calldata priceIds,
		uint64 minPublishTime,
		uint64 maxPublishTime
	) external payable returns (PythStructs.PriceFeed[] memory priceFeeds) {
		return priceFeeds;
	}
	
	function parsePriceFeedUpdatesUnique(
		bytes[] calldata updateData,
		bytes32[] calldata priceIds,
		uint64 minPublishTime,
		uint64 maxPublishTime
	) external payable returns (PythStructs.PriceFeed[] memory priceFeeds) {
		return priceFeeds;
	}
	
}
