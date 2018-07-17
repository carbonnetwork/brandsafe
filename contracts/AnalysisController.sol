pragma solidity ^0.4.23;


import "carbon-ico/contracts/Ownable.sol";

import "./Datastore.sol";
import "./Lockstore.sol";

import "./lib/StringLib.sol";


/**
 * The AnalysisController contract does this and that...
 */
contract AnalysisController is Ownable {

	using StringLib for bytes;

	Datastore ds;
	Lockstore ls;

	uint constant fiveMin = 5 * 60;

	constructor(address datastore, address lockstroe) public {
		ds = Datastore(datastore);
		ls = Lockstore(lockstroe);
	}

	/*
	 * 获取url中的一个，首先从超时未处理的部分获取;
	 */
	function getURL() public view returns(uint _id, bytes _url) {
		if (ls.contains(msg.sender)){
			return (0, "");
		}

		uint index = ls.start();
		address key;
		uint timestamp;

		bytes memory url;
		address sender;
		uint price;

		while (index >= 0 && ls.validIndex(index)){
			(key, _id, timestamp) = ls.get(index);
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
	 * 根据状态获取url和其对应的额id，目前只获取当前状态的第一条
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
		
		return (0, "");
	}
	
	
	/*
	 * 将url的状态从未分析，更新为正在分析的状态，更新成功的话，此用户才分析的结果才会有奖励
	 */
	function lockUrl(uint _id) public{		
		require (_id > 0);

		if (ls.contains(msg.sender)){
			revert();
		}		
		
		uint8 s;
		address sender;
		uint price;

		(,sender, price, s) = ds.getURLByID(_id);
		if (s  > 1 || ds.balanceOf(sender) < price){
			revert();
		}

		if(s == 0){
			ds.changeStatus(1, _id);
		} else {
			address a = ds.getAnalysor(_id);
			if(a != address(0)){
				ls.deleteIt(a);
			}	
		}
		
		ds.setAnalysor(_id, msg.sender);
		ls.put(msg.sender, _id);
	}

	/*
	 * 记录url的类别
	 */	
	function fillCates (uint _id, bytes _url, bytes _cates) public {
	 	require (_id > 0 && _cates.length > 0);
	 	
	 	if(ls.getID(msg.sender) != _id){
	 		revert();
	 	}

	 	bytes memory url;
		address sender;
		uint price;

	 	(url, sender, price,) = ds.getURLByID(_id);
	 	if(_url.bytesEquals(url)){
	 		ds.setResult(_id, _cates, msg.sender);
	 		if (ds.getStatusByID(_id) == 1) {
	 			ds.changeStatus(2,_id);
	 		}
	 		
	 		asyncSend(sender, msg.sender, price);
	 	}
	}

	function asyncSend(address _from, address _to, uint256 _amount) internal {		
		ds.subAmount(_from, _amount);
	    ds.addAmount(_to, _amount);
	}
}
