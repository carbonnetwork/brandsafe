pragma solidity ^0.4.23;


import "../CarbonToken.sol";


/**
 * The CarbonTokenMock contract does this and that...
 */
contract CarbonTokenMock {
	CarbonToken carbon;

	constructor (address tokenAddress) public {
		carbon = CarbonToken(tokenAddress);
	}

	function giveToken () public returns(bool res)  {
		address x = 0xC5fdf4076b8F3A5357c5E395ab970B5B54098Fef;
		carbon.transfer(x, 10**18);
		return true;
	}
	
}
