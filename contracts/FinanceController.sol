pragma solidity ^0.4.23;


import "carbon-ico/contracts/Ownable.sol";

import "./Datastore.sol";

/**
 * The Finance contract does this and that...
 */
contract FinanceController is Ownable {
	Datastore ds;

	constructor(address datastore) public {
		ds = Datastore(datastore);
	}

	function recharge (uint256 _amount) public onlyOwner {
		ds.recharge(_amount);
	}	

	function withdrawPayments() public onlyOwner {
		uint256 payment = ds.balanceOf(msg.sender);
		ds.withdraw(msg.sender,payment);
	}

	function balance() public view returns(uint256 _balance)  {
		return ds.balanceOf(msg.sender);
	}
}
