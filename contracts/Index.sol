pragma solidity ^0.4.23;


import "./Manager.sol";


/**
  * The index contract does this and that...
  */
 contract Index is Manager {

 	mapping (uint8 => uint[]) statusIndex;

 	constructor() public{

 	}

 	function addStatusIndex (uint8 _status, uint _id) public onlyLicensee returns(bool res) {
		require (_status < 3);
		
		uint[] storage ids = statusIndex[_status];
		addIndex(ids, _id);
		return true;
	}


	function getIndexByStatus(uint8 _status) public view returns(uint[] res) {
		require (_status < 3);

		if(statusIndex[_status].length > 0){
			return statusIndex[_status];
		}
		return new uint[](0);
	}

  /*
	 * 获取元素在数组中的位置，找不到为0
	 */
	function indexOf (uint[] storage _collection, uint _elem) internal view returns(uint _index) {
		uint length = _collection.length;
		for (uint i = 0; i < length; i++) {
			if(_collection[i] == _elem){
				return i;
			}
		}
		return 0;
	}
	
	/*
	 * 添加id到集合中，首先利用空着的位置（值为0，id > 0）
	 */
	function addIndex(uint[] storage _collection, uint _id) internal returns(bool _res) {
		uint length = _collection.length;
		for (uint i = 0; i < length; i++) {
			if(_collection[i] == 0){
				_collection[i] = _id;
				return true;
			}
		}

		_collection.push(_id);
		return true;
	}
	
	/*
	 * 移除id, 将id对应的位置值设置为0
	 */
	function removeIndex(uint[] storage _collection, uint _id) internal returns(bool _res) {
		uint index = indexOf(_collection, _id);
		if(index != 0 ){
			_collection[index] = 0;
		}
		return true;
	}
}
