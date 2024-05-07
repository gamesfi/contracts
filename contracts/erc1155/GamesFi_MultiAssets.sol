// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
	/**
	 * @dev Returns the largest of two signed numbers.
     */
	function max(int256 a, int256 b) internal pure returns (int256) {
		return a > b ? a : b;
	}
	
	/**
	 * @dev Returns the smallest of two signed numbers.
     */
	function min(int256 a, int256 b) internal pure returns (int256) {
		return a < b ? a : b;
	}
	
	/**
	 * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
	function average(int256 a, int256 b) internal pure returns (int256) {
		// Formula from the book "Hacker's Delight"
		int256 x = (a & b) + ((a ^ b) >> 1);
		return x + (int256(uint256(x) >> 255) & (a ^ b));
	}
	
	/**
	 * @dev Returns the absolute unsigned value of a signed value.
     */
	function abs(int256 n) internal pure returns (uint256) {
		unchecked {
		// must be unchecked in order to support `n = type(int256).min`
			return uint256(n >= 0 ? n : -n);
		}
	}
}




/**
 * @dev Standard ERC1155 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC1155 tokens.
 */
interface IERC1155Errors {
	/**
	 * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     * @param tokenId Identifier number of a token.
     */
	error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);
	
	/**
	 * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
	error ERC1155InvalidSender(address sender);
	
	/**
	 * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
	error ERC1155InvalidReceiver(address receiver);
	
	/**
	 * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
	error ERC1155MissingApprovalForAll(address operator, address owner);
	
	/**
	 * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
	error ERC1155InvalidApprover(address approver);
	
	/**
	 * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
	error ERC1155InvalidOperator(address operator);
	
	/**
	 * @dev Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
     * Used in batch transfers.
     * @param idsLength Length of the array of token identifiers
     * @param valuesLength Length of the array of token amounts
     */
	error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
}

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 */
library StorageSlot {
	struct AddressSlot {
		address value;
	}
	
	struct BooleanSlot {
		bool value;
	}
	
	struct Bytes32Slot {
		bytes32 value;
	}
	
	struct Uint256Slot {
		uint256 value;
	}
	
	struct StringSlot {
		string value;
	}
	
	struct BytesSlot {
		bytes value;
	}
	
	/**
	 * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
	function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := slot
		}
	}
	
	/**
	 * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
	function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := slot
		}
	}
	
	/**
	 * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
	function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := slot
		}
	}
	
	/**
	 * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
	function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := slot
		}
	}
	
	/**
	 * @dev Returns an `StringSlot` with member `value` located at `slot`.
     */
	function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := slot
		}
	}
	
	/**
	 * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
	function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := store.slot
		}
	}
	
	/**
	 * @dev Returns an `BytesSlot` with member `value` located at `slot`.
     */
	function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := slot
		}
	}
	
	/**
	 * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
	function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
		/// @solidity memory-safe-assembly
		assembly {
			r.slot := store.slot
		}
	}
}

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
	/**
	 * @dev Muldiv operation overflow.
     */
	error MathOverflowedMulDiv();
	
	enum Rounding {
		Floor, // Toward negative infinity
		Ceil, // Toward positive infinity
		Trunc, // Toward zero
		Expand // Away from zero
	}
	
	/**
	 * @dev Returns the addition of two unsigned integers, with an overflow flag.
     */
	function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
		unchecked {
			uint256 c = a + b;
			if (c < a) return (false, 0);
			return (true, c);
		}
	}
	
	/**
	 * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     */
	function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
		unchecked {
			if (b > a) return (false, 0);
			return (true, a - b);
		}
	}
	
	/**
	 * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     */
	function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
		unchecked {
		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
		// benefit is lost if 'b' is also tested.
		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
			if (a == 0) return (true, 0);
			uint256 c = a * b;
			if (c / a != b) return (false, 0);
			return (true, c);
		}
	}
	
	/**
	 * @dev Returns the division of two unsigned integers, with a division by zero flag.
     */
	function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
		unchecked {
			if (b == 0) return (false, 0);
			return (true, a / b);
		}
	}
	
	/**
	 * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     */
	function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
		unchecked {
			if (b == 0) return (false, 0);
			return (true, a % b);
		}
	}
	
	/**
	 * @dev Returns the largest of two numbers.
     */
	function max(uint256 a, uint256 b) internal pure returns (uint256) {
		return a > b ? a : b;
	}
	
	/**
	 * @dev Returns the smallest of two numbers.
     */
	function min(uint256 a, uint256 b) internal pure returns (uint256) {
		return a < b ? a : b;
	}
	
	/**
	 * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
	function average(uint256 a, uint256 b) internal pure returns (uint256) {
		// (a + b) / 2 can overflow.
		return (a & b) + (a ^ b) / 2;
	}
	
	/**
	 * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
	function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
		if (b == 0) {
			// Guarantee the same behavior as in a regular Solidity division.
			return a / b;
		}
		
		// (a + b - 1) / b can overflow on addition, so we distribute.
		return a == 0 ? 0 : (a - 1) / b + 1;
	}
	
	/**
	 * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
	function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
		unchecked {
		// 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
		// use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
		// variables such that product = prod1 * 2^256 + prod0.
			uint256 prod0 = x * y; // Least significant 256 bits of the product
			uint256 prod1; // Most significant 256 bits of the product
			assembly {
				let mm := mulmod(x, y, not(0))
				prod1 := sub(sub(mm, prod0), lt(mm, prod0))
			}
		
		// Handle non-overflow cases, 256 by 256 division.
			if (prod1 == 0) {
				// Solidity will revert if denominator == 0, unlike the div opcode on its own.
				// The surrounding unchecked block does not change this fact.
				// See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
				return prod0 / denominator;
			}
		
		// Make sure the result is less than 2^256. Also prevents denominator == 0.
			if (denominator <= prod1) {
				revert MathOverflowedMulDiv();
			}
		
		///////////////////////////////////////////////
		// 512 by 256 division.
		///////////////////////////////////////////////
		
		// Make division exact by subtracting the remainder from [prod1 prod0].
			uint256 remainder;
			assembly {
			// Compute remainder using mulmod.
				remainder := mulmod(x, y, denominator)
			
			// Subtract 256 bit number from 512 bit number.
				prod1 := sub(prod1, gt(remainder, prod0))
				prod0 := sub(prod0, remainder)
			}
		
		// Factor powers of two out of denominator and compute largest power of two divisor of denominator.
		// Always >= 1. See https://cs.stackexchange.com/q/138556/92363.
			
			uint256 twos = denominator & (0 - denominator);
			assembly {
			// Divide denominator by twos.
				denominator := div(denominator, twos)
			
			// Divide [prod1 prod0] by twos.
				prod0 := div(prod0, twos)
			
			// Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
				twos := add(div(sub(0, twos), twos), 1)
			}
		
		// Shift in bits from prod1 into prod0.
			prod0 |= prod1 * twos;
		
		// Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
		// that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
		// four bits. That is, denominator * inv = 1 mod 2^4.
			uint256 inverse = (3 * denominator) ^ 2;
		
		// Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
		// works in modular arithmetic, doubling the correct bits in each step.
			inverse *= 2 - denominator * inverse; // inverse mod 2^8
			inverse *= 2 - denominator * inverse; // inverse mod 2^16
			inverse *= 2 - denominator * inverse; // inverse mod 2^32
			inverse *= 2 - denominator * inverse; // inverse mod 2^64
			inverse *= 2 - denominator * inverse; // inverse mod 2^128
			inverse *= 2 - denominator * inverse; // inverse mod 2^256
		
		// Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
		// This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
		// less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
		// is no longer required.
			result = prod0 * inverse;
			return result;
		}
	}
	
	/**
	 * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
	function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
		uint256 result = mulDiv(x, y, denominator);
		if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
			result += 1;
		}
		return result;
	}
	
	/**
	 * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
	function sqrt(uint256 a) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		
		// For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
		//
		// We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
		// `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
		//
		// This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
		// → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
		// → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
		//
		// Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
		uint256 result = 1 << (log2(a) >> 1);
		
		// At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
		// since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
		// every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
		// into the expected uint128 result.
		unchecked {
			result = (result + a / result) >> 1;
			result = (result + a / result) >> 1;
			result = (result + a / result) >> 1;
			result = (result + a / result) >> 1;
			result = (result + a / result) >> 1;
			result = (result + a / result) >> 1;
			result = (result + a / result) >> 1;
			return min(result, a / result);
		}
	}
	
	/**
	 * @notice Calculates sqrt(a), following the selected rounding direction.
     */
	function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
		unchecked {
			uint256 result = sqrt(a);
			return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
		}
	}
	
	/**
	 * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
	function log2(uint256 value) internal pure returns (uint256) {
		uint256 result = 0;
		unchecked {
			if (value >> 128 > 0) {
				value >>= 128;
				result += 128;
			}
			if (value >> 64 > 0) {
				value >>= 64;
				result += 64;
			}
			if (value >> 32 > 0) {
				value >>= 32;
				result += 32;
			}
			if (value >> 16 > 0) {
				value >>= 16;
				result += 16;
			}
			if (value >> 8 > 0) {
				value >>= 8;
				result += 8;
			}
			if (value >> 4 > 0) {
				value >>= 4;
				result += 4;
			}
			if (value >> 2 > 0) {
				value >>= 2;
				result += 2;
			}
			if (value >> 1 > 0) {
				result += 1;
			}
		}
		return result;
	}
	
	/**
	 * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
	function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
		unchecked {
			uint256 result = log2(value);
			return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
		}
	}
	
	/**
	 * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
	function log10(uint256 value) internal pure returns (uint256) {
		uint256 result = 0;
		unchecked {
			if (value >= 10 ** 64) {
				value /= 10 ** 64;
				result += 64;
			}
			if (value >= 10 ** 32) {
				value /= 10 ** 32;
				result += 32;
			}
			if (value >= 10 ** 16) {
				value /= 10 ** 16;
				result += 16;
			}
			if (value >= 10 ** 8) {
				value /= 10 ** 8;
				result += 8;
			}
			if (value >= 10 ** 4) {
				value /= 10 ** 4;
				result += 4;
			}
			if (value >= 10 ** 2) {
				value /= 10 ** 2;
				result += 2;
			}
			if (value >= 10 ** 1) {
				result += 1;
			}
		}
		return result;
	}
	
	/**
	 * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
	function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
		unchecked {
			uint256 result = log10(value);
			return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
		}
	}
	
	/**
	 * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
	function log256(uint256 value) internal pure returns (uint256) {
		uint256 result = 0;
		unchecked {
			if (value >> 128 > 0) {
				value >>= 128;
				result += 16;
			}
			if (value >> 64 > 0) {
				value >>= 64;
				result += 8;
			}
			if (value >> 32 > 0) {
				value >>= 32;
				result += 4;
			}
			if (value >> 16 > 0) {
				value >>= 16;
				result += 2;
			}
			if (value >> 8 > 0) {
				result += 1;
			}
		}
		return result;
	}
	
	/**
	 * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
	function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
		unchecked {
			uint256 result = log256(value);
			return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
		}
	}
	
	/**
	 * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
	function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
		return uint8(rounding) % 2 == 1;
	}
}


/**
 * @dev Collection of functions related to array types.
 */
library Arrays {
	using StorageSlot for bytes32;
	
	/**
	 * @dev Searches a sorted `array` and returns the first index that contains
     * a value greater or equal to `element`. If no such index exists (i.e. all
     * values in the array are strictly less than `element`), the array length is
     * returned. Time complexity O(log n).
     *
     * `array` is expected to be sorted in ascending order, and to contain no
     * repeated elements.
     */
	function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
		uint256 low = 0;
		uint256 high = array.length;
		
		if (high == 0) {
			return 0;
		}
		
		while (low < high) {
			uint256 mid = Math.average(low, high);
			
			// Note that mid will always be strictly less than high (i.e. it will be a valid array index)
			// because Math.average rounds towards zero (it does integer division with truncation).
			if (unsafeAccess(array, mid).value > element) {
				high = mid;
			} else {
				low = mid + 1;
			}
		}
		
		// At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
		if (low > 0 && unsafeAccess(array, low - 1).value == element) {
			return low - 1;
		} else {
			return low;
		}
	}
	
	/**
	 * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
	function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
		bytes32 slot;
		// We use assembly to calculate the storage slot of the element at index `pos` of the dynamic array `arr`
		// following https://docs.soliditylang.org/en/v0.8.20/internals/layout_in_storage.html#mappings-and-dynamic-arrays.
		
		/// @solidity memory-safe-assembly
		assembly {
			mstore(0, arr.slot)
			slot := add(keccak256(0, 0x20), pos)
		}
		return slot.getAddressSlot();
	}
	
	/**
	 * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
	function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
		bytes32 slot;
		// We use assembly to calculate the storage slot of the element at index `pos` of the dynamic array `arr`
		// following https://docs.soliditylang.org/en/v0.8.20/internals/layout_in_storage.html#mappings-and-dynamic-arrays.
		
		/// @solidity memory-safe-assembly
		assembly {
			mstore(0, arr.slot)
			slot := add(keccak256(0, 0x20), pos)
		}
		return slot.getBytes32Slot();
	}
	
	/**
	 * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
	function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
		bytes32 slot;
		// We use assembly to calculate the storage slot of the element at index `pos` of the dynamic array `arr`
		// following https://docs.soliditylang.org/en/v0.8.20/internals/layout_in_storage.html#mappings-and-dynamic-arrays.
		
		/// @solidity memory-safe-assembly
		assembly {
			mstore(0, arr.slot)
			slot := add(keccak256(0, 0x20), pos)
		}
		return slot.getUint256Slot();
	}
	
	/**
	 * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
	function unsafeMemoryAccess(uint256[] memory arr, uint256 pos) internal pure returns (uint256 res) {
		assembly {
			res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
		}
	}
	
	/**
	 * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
	function unsafeMemoryAccess(address[] memory arr, uint256 pos) internal pure returns (address res) {
		assembly {
			res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
		}
	}
}


/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
	/**
	 * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
	function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
	/**
	 * @dev See {IERC165-supportsInterface}.
     */
	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
		return interfaceId == type(IERC165).interfaceId;
	}
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
	function _msgSender() internal view virtual returns (address) {
		return msg.sender;
	}
	
	function _msgData() internal view virtual returns (bytes calldata) {
		return msg.data;
	}
}
/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
	/**
	 * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
	event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
	
	/**
	 * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
	event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
	
	/**
	 * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
	event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
	
	/**
	 * @dev Returns `true` if `account` has been granted `role`.
     */
	function hasRole(bytes32 role, address account) external view returns (bool);
	
	/**
	 * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
	function getRoleAdmin(bytes32 role) external view returns (bytes32);
	
	/**
	 * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
	function grantRole(bytes32 role, address account) external;
	
	/**
	 * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
	function revokeRole(bytes32 role, address account) external;
	
	/**
	 * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
	function renounceRole(bytes32 role, address account) external;
}

/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
	struct RoleData {
		mapping(address => bool) members;
		bytes32 adminRole;
	}
	
	mapping(bytes32 => RoleData) private _roles;
	
	bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
	
	/**
	 * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
	modifier onlyRole(bytes32 role) {
		_checkRole(role);
		_;
	}
	
	/**
	 * @dev See {IERC165-supportsInterface}.
     */
	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
		return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
	}
	
	/**
	 * @dev Returns `true` if `account` has been granted `role`.
     */
	function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
		return _roles[role].members[account];
	}
	
	/**
	 * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
	function _checkRole(bytes32 role) internal view virtual {
		_checkRole(role, _msgSender());
	}
	
	/**
	 * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
	function _checkRole(bytes32 role, address account) internal view virtual {
		if (!hasRole(role, account)) {
			revert(
				string(
				abi.encodePacked(
					"AccessControl: account ",
					Strings.toHexString(uint160(account), 20),
					" is missing role ",
					Strings.toHexString(uint256(role), 32)
				)
			)
			);
		}
	}
	
	/**
	 * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
	function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
		return _roles[role].adminRole;
	}
	
	/**
	 * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
	function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
		_grantRole(role, account);
	}
	
	/**
	 * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
	function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
		_revokeRole(role, account);
	}
	
	/**
	 * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     *
     * May emit a {RoleRevoked} event.
     */
	function renounceRole(bytes32 role, address account) public virtual override {
		require(account == _msgSender(), "AccessControl: can only renounce roles for self");
		
		_revokeRole(role, account);
	}
	
	/**
	 * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * May emit a {RoleGranted} event.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
	function _setupRole(bytes32 role, address account) internal virtual {
		_grantRole(role, account);
	}
	
	/**
	 * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
	function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
		bytes32 previousAdminRole = getRoleAdmin(role);
		_roles[role].adminRole = adminRole;
		emit RoleAdminChanged(role, previousAdminRole, adminRole);
	}
	
	/**
	 * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
	function _grantRole(bytes32 role, address account) internal virtual {
		if (!hasRole(role, account)) {
			_roles[role].members[account] = true;
			emit RoleGranted(role, account, _msgSender());
		}
	}
	
	/**
	 * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
	function _revokeRole(bytes32 role, address account) internal virtual {
		if (hasRole(role, account)) {
			_roles[role].members[account] = false;
			emit RoleRevoked(role, account, _msgSender());
		}
	}
}

/**
 * @dev String operations.
 */
library Strings {
	bytes16 private constant HEX_DIGITS = "0123456789abcdef";
	uint8 private constant ADDRESS_LENGTH = 20;
	
	/**
	 * @dev The `value` string doesn't fit in the specified `length`.
     */
	error StringsInsufficientHexLength(uint256 value, uint256 length);
	
	/**
	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
	function toString(uint256 value) internal pure returns (string memory) {
		unchecked {
			uint256 length = Math.log10(value) + 1;
			string memory buffer = new string(length);
			uint256 ptr;
		/// @solidity memory-safe-assembly
			assembly {
				ptr := add(buffer, add(32, length))
			}
			while (true) {
				ptr--;
				/// @solidity memory-safe-assembly
				assembly {
					mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
				}
				value /= 10;
				if (value == 0) break;
			}
			return buffer;
		}
	}
	
	/**
	 * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
	function toStringSigned(int256 value) internal pure returns (string memory) {
		return string.concat(value < 0 ? "-" : "", toString(SignedMath.abs(value)));
	}
	
	/**
	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
	function toHexString(uint256 value) internal pure returns (string memory) {
		unchecked {
			return toHexString(value, Math.log256(value) + 1);
		}
	}
	
	/**
	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
		uint256 localValue = value;
		bytes memory buffer = new bytes(2 * length + 2);
		buffer[0] = "0";
		buffer[1] = "x";
		for (uint256 i = 2 * length + 1; i > 1; --i) {
			buffer[i] = HEX_DIGITS[localValue & 0xf];
			localValue >>= 4;
		}
		if (localValue != 0) {
			revert StringsInsufficientHexLength(value, length);
		}
		return string(buffer);
	}
	
	/**
	 * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal
     * representation.
     */
	function toHexString(address addr) internal pure returns (string memory) {
		return toHexString(uint256(uint160(addr)), ADDRESS_LENGTH);
	}
	
	/**
	 * @dev Returns true if the two strings are equal.
     */
	function equal(string memory a, string memory b) internal pure returns (bool) {
		return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
	}
}

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 */
interface IERC1155 is IERC165 {
	/**
	 * @dev Emitted when `value` amount of tokens of type `id` are transferred from `from` to `to` by `operator`.
     */
	event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
	
	/**
	 * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
	event TransferBatch(
		address indexed operator,
		address indexed from,
		address indexed to,
		uint256[] ids,
		uint256[] values
	);
	
	/**
	 * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
	event ApprovalForAll(address indexed account, address indexed operator, bool approved);
	
	/**
	 * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
	event URI(string value, uint256 indexed id);
	
	/**
	 * @dev Returns the value of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
	function balanceOf(address account, uint256 id) external view returns (uint256);
	
	/**
	 * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
	function balanceOfBatch(
		address[] calldata accounts,
		uint256[] calldata ids
	) external view returns (uint256[] memory);
	
	/**
	 * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
	function setApprovalForAll(address operator, bool approved) external;
	
	/**
	 * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
	function isApprovedForAll(address account, address operator) external view returns (bool);
	
	/**
	 * @dev Transfers a `value` amount of tokens of type `id` from `from` to `to`.
     *
     * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
     * to an untrusted contract, when invoking {onERC1155Received} on the receiver.
     * Ensure to follow the checks-effects-interactions pattern and consider employing
     * reentrancy guards when interacting with untrusted contracts.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `value` amount.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
	function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external;
	
	/**
	 * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
     * to an untrusted contract, when invoking {onERC1155BatchReceived} on the receiver.
     * Ensure to follow the checks-effects-interactions pattern and consider employing
     * reentrancy guards when interacting with untrusted contracts.
     *
     * Emits either a {TransferSingle} or a {TransferBatch} event, depending on the length of the array arguments.
     *
     * Requirements:
     *
     * - `ids` and `values` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
	function safeBatchTransferFrom(
		address from,
		address to,
		uint256[] calldata ids,
		uint256[] calldata values,
		bytes calldata data
	) external;
}

/**
 * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
 * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
 */
interface IERC1155MetadataURI is IERC1155 {
	/**
	 * @dev Returns the URI for token type `id`.
     *
     * If the `\{id\}` substring is present in the URI, it must be replaced by
     * clients with the actual token type ID.
     */
	function uri(uint256 id) external view returns (string memory);
}


/**
 * @dev Interface that must be implemented by smart contracts in order to receive
 * ERC-1155 token transfers.
 */
interface IERC1155Receiver is IERC165 {
	/**
	 * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
	function onERC1155Received(
		address operator,
		address from,
		uint256 id,
		uint256 value,
		bytes calldata data
	) external returns (bytes4);
	
	/**
	 * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
	function onERC1155BatchReceived(
		address operator,
		address from,
		uint256[] calldata ids,
		uint256[] calldata values,
		bytes calldata data
	) external returns (bytes4);
}

/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 */
abstract contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI, IERC1155Errors {
	using Arrays for uint256[];
	using Arrays for address[];
	
	mapping(uint256 id => mapping(address account => uint256)) private _balances;
	
	mapping(address account => mapping(address operator => bool)) private _operatorApprovals;
	
	// Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
	string private _uri;
	
	/**
	 * @dev See {_setURI}.
     */
	constructor(string memory uri_) {
		_setURI(uri_);
	}
	
	/**
	 * @dev See {IERC165-supportsInterface}.
     */
	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
		return
			interfaceId == type(IERC1155).interfaceId ||
			interfaceId == type(IERC1155MetadataURI).interfaceId ||
			super.supportsInterface(interfaceId);
	}
	
	function getUri() public view returns (string memory) {
		return _uri;
	}
	/**
	 * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
	function uri(uint256 /* id */) public view virtual returns (string memory) {
		return _uri;
	}
	
	/**
	 * @dev See {IERC1155-balanceOf}.
     */
	function balanceOf(address account, uint256 id) public view virtual returns (uint256) {
		return _balances[id][account];
	}
	
	/**
	 * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
	function balanceOfBatch(
		address[] memory accounts,
		uint256[] memory ids
	) public view virtual returns (uint256[] memory) {
		if (accounts.length != ids.length) {
			revert ERC1155InvalidArrayLength(ids.length, accounts.length);
		}
		
		uint256[] memory batchBalances = new uint256[](accounts.length);
		
		for (uint256 i = 0; i < accounts.length; ++i) {
			batchBalances[i] = balanceOf(accounts.unsafeMemoryAccess(i), ids.unsafeMemoryAccess(i));
		}
		
		return batchBalances;
	}
	
	/**
	 * @dev See {IERC1155-setApprovalForAll}.
     */
	function setApprovalForAll(address operator, bool approved) public virtual {
		_setApprovalForAll(_msgSender(), operator, approved);
	}
	
	/**
	 * @dev See {IERC1155-isApprovedForAll}.
     */
	function isApprovedForAll(address account, address operator) public view virtual returns (bool) {
		return _operatorApprovals[account][operator];
	}
	
	/**
	 * @dev See {IERC1155-safeTransferFrom}.
     */
	function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) public virtual {
		address sender = _msgSender();
		if (from != sender && !isApprovedForAll(from, sender)) {
			revert ERC1155MissingApprovalForAll(sender, from);
		}
		_safeTransferFrom(from, to, id, value, data);
	}
	
	/**
	 * @dev See {IERC1155-safeBatchTransferFrom}.
     */
	function safeBatchTransferFrom(
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory values,
		bytes memory data
	) public virtual {
		address sender = _msgSender();
		if (from != sender && !isApprovedForAll(from, sender)) {
			revert ERC1155MissingApprovalForAll(sender, from);
		}
		_safeBatchTransferFrom(from, to, ids, values, data);
	}
	
	/**
	 * @dev Transfers a `value` amount of tokens of type `id` from `from` to `to`. Will mint (or burn) if `from`
     * (or `to`) is the zero address.
     *
     * Emits a {TransferSingle} event if the arrays contain one element, and {TransferBatch} otherwise.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement either {IERC1155Receiver-onERC1155Received}
     *   or {IERC1155Receiver-onERC1155BatchReceived} and return the acceptance magic value.
     * - `ids` and `values` must have the same length.
     *
     * NOTE: The ERC-1155 acceptance check is not performed in this function. See {_updateWithAcceptanceCheck} instead.
     */
	function _update(address from, address to, uint256[] memory ids, uint256[] memory values) internal virtual {
		if (ids.length != values.length) {
			revert ERC1155InvalidArrayLength(ids.length, values.length);
		}
		
		address operator = _msgSender();
		
		for (uint256 i = 0; i < ids.length; ++i) {
			uint256 id = ids.unsafeMemoryAccess(i);
			uint256 value = values.unsafeMemoryAccess(i);
			
			if (from != address(0)) {
				uint256 fromBalance = _balances[id][from];
				if (fromBalance < value) {
					revert ERC1155InsufficientBalance(from, fromBalance, value, id);
				}
				unchecked {
				// Overflow not possible: value <= fromBalance
					_balances[id][from] = fromBalance - value;
				}
			}
			
			if (to != address(0)) {
				_balances[id][to] += value;
			}
		}
		
		if (ids.length == 1) {
			uint256 id = ids.unsafeMemoryAccess(0);
			uint256 value = values.unsafeMemoryAccess(0);
			emit TransferSingle(operator, from, to, id, value);
		} else {
			emit TransferBatch(operator, from, to, ids, values);
		}
	}
	
	/**
	 * @dev Version of {_update} that performs the token acceptance check by calling
     * {IERC1155Receiver-onERC1155Received} or {IERC1155Receiver-onERC1155BatchReceived} on the receiver address if it
     * contains code (eg. is a smart contract at the moment of execution).
     *
     * IMPORTANT: Overriding this function is discouraged because it poses a reentrancy risk from the receiver. So any
     * update to the contract state after this function would break the check-effect-interaction pattern. Consider
     * overriding {_update} instead.
     */
	function _updateWithAcceptanceCheck(
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory values,
		bytes memory data
	) internal virtual {
		_update(from, to, ids, values);
		if (to != address(0)) {
			address operator = _msgSender();
			if (ids.length == 1) {
				uint256 id = ids.unsafeMemoryAccess(0);
				uint256 value = values.unsafeMemoryAccess(0);
				_doSafeTransferAcceptanceCheck(operator, from, to, id, value, data);
			} else {
				_doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, values, data);
			}
		}
	}
	
	/**
	 * @dev Transfers a `value` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `from` must have a balance of tokens of type `id` of at least `value` amount.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
	function _safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) internal {
		if (to == address(0)) {
			revert ERC1155InvalidReceiver(address(0));
		}
		if (from == address(0)) {
			revert ERC1155InvalidSender(address(0));
		}
		(uint256[] memory ids, uint256[] memory values) = _asSingletonArrays(id, value);
		_updateWithAcceptanceCheck(from, to, ids, values, data);
	}
	
	/**
	 * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     * - `ids` and `values` must have the same length.
     */
	function _safeBatchTransferFrom(
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory values,
		bytes memory data
	) internal {
		if (to == address(0)) {
			revert ERC1155InvalidReceiver(address(0));
		}
		if (from == address(0)) {
			revert ERC1155InvalidSender(address(0));
		}
		_updateWithAcceptanceCheck(from, to, ids, values, data);
	}
	
	/**
	 * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the values in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
	function _setURI(string memory newuri) internal virtual {
		_uri = newuri;
	}
	
	/**
	 * @dev Creates a `value` amount of tokens of type `id`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
	function _mint(address to, uint256 id, uint256 value, bytes memory data) internal {
		if (to == address(0)) {
			revert ERC1155InvalidReceiver(address(0));
		}
		(uint256[] memory ids, uint256[] memory values) = _asSingletonArrays(id, value);
		_updateWithAcceptanceCheck(address(0), to, ids, values, data);
	}
	
	/**
	 * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `values` must have the same length.
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
	function _mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal {
		if (to == address(0)) {
			revert ERC1155InvalidReceiver(address(0));
		}
		_updateWithAcceptanceCheck(address(0), to, ids, values, data);
	}
	
	/**
	 * @dev Destroys a `value` amount of tokens of type `id` from `from`
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `value` amount of tokens of type `id`.
     */
	function _burn(address from, uint256 id, uint256 value) internal {
		if (from == address(0)) {
			revert ERC1155InvalidSender(address(0));
		}
		(uint256[] memory ids, uint256[] memory values) = _asSingletonArrays(id, value);
		_updateWithAcceptanceCheck(from, address(0), ids, values, "");
	}
	
	/**
	 * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `value` amount of tokens of type `id`.
     * - `ids` and `values` must have the same length.
     */
	function _burnBatch(address from, uint256[] memory ids, uint256[] memory values) internal {
		if (from == address(0)) {
			revert ERC1155InvalidSender(address(0));
		}
		_updateWithAcceptanceCheck(from, address(0), ids, values, "");
	}
	
	/**
	 * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the zero address.
     */
	function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
		if (operator == address(0)) {
			revert ERC1155InvalidOperator(address(0));
		}
		_operatorApprovals[owner][operator] = approved;
		emit ApprovalForAll(owner, operator, approved);
	}
	
	/**
	 * @dev Performs an acceptance check by calling {IERC1155-onERC1155Received} on the `to` address
     * if it contains code at the moment of execution.
     */
	function _doSafeTransferAcceptanceCheck(
		address operator,
		address from,
		address to,
		uint256 id,
		uint256 value,
		bytes memory data
	) private {
		if (to.code.length > 0) {
			try IERC1155Receiver(to).onERC1155Received(operator, from, id, value, data) returns (bytes4 response) {
				if (response != IERC1155Receiver.onERC1155Received.selector) {
					// Tokens rejected
					revert ERC1155InvalidReceiver(to);
				}
			} catch (bytes memory reason) {
				if (reason.length == 0) {
					// non-ERC1155Receiver implementer
					revert ERC1155InvalidReceiver(to);
				} else {
					/// @solidity memory-safe-assembly
					assembly {
						revert(add(32, reason), mload(reason))
					}
				}
			}
		}
	}
	
	/**
	 * @dev Performs a batch acceptance check by calling {IERC1155-onERC1155BatchReceived} on the `to` address
     * if it contains code at the moment of execution.
     */
	function _doSafeBatchTransferAcceptanceCheck(
		address operator,
		address from,
		address to,
		uint256[] memory ids,
		uint256[] memory values,
		bytes memory data
	) private {
		if (to.code.length > 0) {
			try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, values, data) returns (
				bytes4 response
			) {
				if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
					// Tokens rejected
					revert ERC1155InvalidReceiver(to);
				}
			} catch (bytes memory reason) {
				if (reason.length == 0) {
					// non-ERC1155Receiver implementer
					revert ERC1155InvalidReceiver(to);
				} else {
					/// @solidity memory-safe-assembly
					assembly {
						revert(add(32, reason), mload(reason))
					}
				}
			}
		}
	}
	
	/**
	 * @dev Creates an array in memory with only one value for each of the elements provided.
     */
	function _asSingletonArrays(
		uint256 element1,
		uint256 element2
	) private pure returns (uint256[] memory array1, uint256[] memory array2) {
		/// @solidity memory-safe-assembly
		assembly {
		// Load the free memory pointer
			array1 := mload(0x40)
		// Set array length to 1
			mstore(array1, 1)
		// Store the single element at the next word after the length (where content starts)
			mstore(add(array1, 0x20), element1)
		
		// Repeat for next array locating it right after the first array
			array2 := add(array1, 0x40)
			mstore(array2, 1)
			mstore(add(array2, 0x20), element2)
		
		// Update the free memory pointer by pointing after the second array
			mstore(0x40, add(array2, 0x40))
		}
	}
}

contract GamesFi_MultiAsset is AccessControl, ERC1155 {
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
	
	string public _baseTokenURI = "https://nft.gamesfi.org/erc1155/token/";
	
	
	constructor() ERC1155(_baseTokenURI) {
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}
	
	function setBaseURI(string calldata uri_) external {
		require(
			hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
			"unauthorized access"
		);
		_setURI(uri_);
	}
	
	/**
 * @dev Converts a uint256 to its ASCII string decimal representation.
     */
	function _toString(uint256 value) internal pure virtual returns (string memory str) {
		assembly {
		// The maximum value of a uint256 contains 78 digits (1 byte per digit),
		// but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
		// We will need 1 32-byte word to store the length,
		// and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
			str := add(mload(0x40), 0x80)
		// Update the free memory pointer to allocate.
			mstore(0x40, str)
		
		// Cache the end of the memory to calculate the length later.
			let end := str
		
		// We write the string from rightmost digit to leftmost digit.
		// The following is essentially a do-while loop that also handles the zero case.
		// prettier-ignore
			for { let temp := value } 1 {} {
				str := sub(str, 1)
			// Write the character to the pointer.
			// The ASCII index of the '0' character is 48.
				mstore8(str, add(48, mod(temp, 10)))
			// Keep dividing `temp` until zero.
				temp := div(temp, 10)
			// prettier-ignore
				if iszero(temp) { break }
			}
			
			let length := sub(end, str)
		// Move the pointer 32 bytes leftwards to make room for the length.
			str := sub(str, 0x20)
		// Store the length.
			mstore(str, length)
		}
	}
	/**
 	 * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
	function uri(uint256  id) public view override virtual returns (string memory) {
		return string(abi.encodePacked(getUri(), _toString(id)));
	}
	
	function supportsInterface(bytes4 interfaceId)
	public
	view
	virtual
	override(AccessControl, ERC1155)
	returns (bool)
	{
		return
			interfaceId == type(IAccessControl).interfaceId ||
			interfaceId == type(IERC1155).interfaceId ||
			interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
			interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
			interfaceId == 0x5b5e139f || // ERC165 interface ID for ERC721Metadata.
			super.supportsInterface(interfaceId);
	}
	
	
	function mint(address to, uint256 id, uint256 size) external {
		require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
		require(to != address(0), "can't mint to empty address");
		require(size > 0, "size must greater than zero");
		require(id > 0, "id must greater than zero");
		_mint(to, id, size, "");
	} // end of mint function
	
	function mintBatch(address to, uint256[] memory ids, uint256[] memory values) external {
		require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
		require(to != address(0), "can't mint to empty address");
		require(values.length > 0, "values must greater than zero");
		require(ids.length > 0, "ids must greater than zero");
		_mintBatch(to, ids, values, "");
	} // end of mint function
	
	
	function burn(address from, uint256 id, uint256 amount) public {
		require(from == _msgSender() || isApprovedForAll(from, _msgSender()),"ERC1155: caller is not token owner or approved");
		_burn( from,  id,  amount);
	}
	
	function burnBatch(address from, uint256[] memory ids, uint256[] memory amounts)public {
		require(from == _msgSender() || isApprovedForAll(from, _msgSender()),"ERC1155: caller is not token owner or approved");
		_burnBatch(from,ids,amounts);
	}
	
	
}
