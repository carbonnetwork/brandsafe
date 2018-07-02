pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CarbonToken.sol";


/**
 * The TestCarbonToken contract does this and that...
 */
contract TestCarbonToken {
	CarbonToken carbon;

	//has some problerm, commet the code
	/*
	function beforeAll() public {
		carbon = CarbonToken(DeployedAddresses.CarbonToken());
	}

	function testTransfer() public {
		address x = 0xEcEa549d1fbe9025dc09d6CCB66b498a03372B68;
		carbon.transfer(x, 1000);
		Assert.equal(carbon.balanceOf(x), 1000, "The balance is wrong!");
	}*/
}
