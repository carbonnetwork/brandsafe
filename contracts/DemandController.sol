pragma solidity ^0.4.23;

import "./Datastore.sol";

import "carbon-ico/contracts/Ownable.sol";

/**
 * The DemandController contract does this and that...
 */
contract DemandController {
	Datastore ds;
	
	constructor(address datastore) public{
		ds = Datastore(datastore);
	}

	/*
	 * add new url to contract
	 */
	function addURL(bytes _url, uint _price) public returns(bool res) {		
		ds.insertURL(_url, _price, msg.sender);
		return true;
	}

	/*
	 * query url categories
	 */
	function query (bytes _url) public view returns(bytes cates) {
		return ds.getCates(msg.sender, _url);
	}
}
