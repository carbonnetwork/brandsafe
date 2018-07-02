pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/test/Array.sol";


/**
 * The TestArray contract does this and that...
 */
contract TestArray {
	Array ar;
	function beforeAll () public {
		ar = Array(DeployedAddresses.Array());
	}

	function testReturnValue () public {
		//uint[] storage v = ar.getArray();
		Assert.equal(ar.getArray().length, 3, "Array length incorrect.");
	}
}

