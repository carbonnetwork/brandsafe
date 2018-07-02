pragma solidity ^0.4.23;

/**
 * The Array contract does this and that...
 */
contract Array {
	uint[] x;

	constructor () public {	
		x = [uint(1),2,3];
	}

	function getArray () public view returns(uint[] res) {
		return x;
	}

}
