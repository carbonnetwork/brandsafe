pragma solidity ^0.4.23;



import "carbon-ico/contracts/Ownable.sol";

import "./Datastore.sol";
import "./Lockstore.sol";

import "./lib/StringLib.sol";


/**
 * The AnalysisController contract does this and that...
 */
contract AnalysisController {

	using StringLib for bytes;

	Datastore ds;
	Lockstore ls;

	uint constant fiveMin = 5 * 60;

	constructor(address datastore, address lockstroe) public{
		ds = Datastore(datastore);
		ls = Lockstore(lockstroe);
	}

	/*
	 * 
	 */
	function getURL() public view returns(uint _id, bytes _url) {
		if (ls.contains(msg.sender)){
			return (0, "current analysor in lock!");
		}

		uint index = ls.start();
		address key;
		uint timestamp;

		bytes memory url;
		address sender;
		uint price;

		while (index >= 0 && ls.validIndex(index)){
			(key, _id, timestamp) = ls.getByIndex(index);
			if ( _id > 0 && now > timestamp + fiveMin){
				(url, sender, price,) = ds.getURLByID(_id);

				if (ds.balanceOf(sender) >= price){
					return (_id, url);
				}				
			}

			index = ls.next(index);
		}

		return getURLByStatus(0);
	}
	

	/*
	 * 
	 */
	function getURLByStatus(uint8 _status) public view returns(uint _id, bytes _url) {
		uint[] memory ns = ds.getIndexByStatus(_status);

		bytes memory url;
		address sender;
		uint price;

		uint length = ns.length;
		for( uint i = 0; i < length; i++){
			uint uid = ns[i];
			(url, sender, price,) = ds.getURLByID(uid);
			if (sender != address(0) && ds.balanceOf(sender) >= price){
				return (uid, url);
			}
		}
		
		return (0, "No url for current analysor");
	}
	
	
	/*
	 * lock url, when you lock it success,you can process it
	 */
	function lockUrl(uint _id) public{		
		require (_id > 0);

		// The current analysor has job in progress
		if (ls.contains(msg.sender)){
			revert("You have job not submitted.");
		}		
		
		uint8 s;
		address sender;
		uint price;

		(,sender, price, s) = ds.getURLByID(_id);

		// The sender's balance not enough
		if (ds.balanceOf(sender) < price){
			revert("The url sender has not enough tokens.");
		}

		checkStatus(_id, s);
		
		// set analysor to who get the job
		ds.setAnalysor(_id, msg.sender);
		ls.put(msg.sender, _id);
	}

	/*
	 *
	 */
	function checkStatus (uint _id, uint8 s) internal {
		// processed completed
		if (s > 1 ){
			revert("The job has been processed.");
		} else if (s == 1) {
			address a = ds.getAnalysor(_id);

			if(a != address(0)){
				uint timestamp;

				(, timestamp) = ls.get(a);
				// timeout
				if (now > timestamp + fiveMin){
					ls.deleteIt(a);
				} else {
					// being processed by another analysor
					revert("The job is being processed by another analysor.");
				}			
			}		
		} else if(s == 0){
			// change status to in progress
			ds.changeStatus(1, _id);
		} 
	}


	/*
	 * record url categroies
	 */	
	function fillCates (uint _id, bytes _url, bytes _cates) public {
	 	require (_id > 0 && _cates.length > 0);

	 	if(ls.getID(msg.sender) != _id){
	 		revert("The job is not processing.");
	 	}

	 	bytes memory url;
		address sender;
		uint price;
		uint8 s;

	 	(url, sender, price, s) = ds.getURLByID(_id);
	 	if(_url.bytesEquals(url)){
	 		ds.setResult(_id, _cates, msg.sender);
	 		if (s == 1) {
	 			ds.changeStatus(2,_id);
	 		}
	 		
	 		ds.asyncSend(sender, msg.sender, price);
	 		ls.deleteIt(msg.sender);
	 	}else{
	 		revert("The url is not correct.");
	 	}
	}
}
