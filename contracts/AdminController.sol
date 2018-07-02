pragma solidity ^0.4.23;

import "carbon-ico/contracts/Ownable.sol";

import "./Datastore.sol";


/**
 * The AdminController contract does this and that...
 */
contract AdminController is Ownable {

	Datastore ds;

	constructor(address datastore) public {
		ds = Datastore(datastore);
	}

	function recharge (address sender, uint256 _amount) public onlyOwner {
		ds.addAmount(sender, _amount);
	}	

	function withdrawPayments(address analysor) public onlyOwner {
		uint256 payment = ds.balanceOf(analysor);
		ds.subAmount(analysor,payment);
	}
}

