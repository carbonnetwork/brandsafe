pragma solidity ^0.4.23;

import "carbon-ico/contracts/Ownable.sol";

import "./Datastore.sol";
/**
 * The DemandController contract does this and that...
 */
contract DemandController is Ownable{
	Datastore ds;

	constructor(address datastore) public {
		ds = Datastore(datastore);
	}

	/*
	 * 添加新的url
	 */
	function addURL(bytes _url, uint _price) public returns(bool res) {		
		ds.insertURL(_url, _price, msg.sender);
		return true;
	}

}
