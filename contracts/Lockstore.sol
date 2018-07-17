pragma solidity ^0.4.23;


import "./Manager.sol";

import "./lib/MapLib.sol";



/**
 * The Lock contract does this and that...
 */
contract Lockstore is Manager {
	using MapLib for MapLib.LockMap;
	MapLib.LockMap lockMap;

	constructor () public {
		
	}

	function put (address user, uint id) public onlyLicensee returns(bool res) {
		lockMap.put(user, id);
		return true;
	}
	

	function contains (address user) public view returns(bool res)  {
		return lockMap.contains(user);
	}
 
	function start() public view returns(uint index){
		return lockMap.iterateStart();
	}

	function get (uint index) public view returns(address key, uint id, uint timestamp) {
		return lockMap.iterateGet(index);
	}

	function getID (address user) public view returns(uint id) {
		return lockMap.get(user);
	}
	
	function validIndex (uint index) public view returns(bool res) {
		return lockMap.iterateValid(index);
	}
	
	function deleteIt (address key) public onlyLicensee returns(bool res) {
		lockMap.remove(key);
		return true;
	}
	

	function next(uint index) public view returns(uint res) {
		return lockMap.iterateNext(index);
	}
	
}
