pragma solidity ^0.4.23;

/**
 * The ArraysLib library does this and that...
 */
library ArraysLib {
  /*
	 * 获取元素在数组中的位置，找不到为0
	 */
	function indexOf (uint[] storage _collection, uint _elem) public view returns(uint _index) {
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
	function addIndex(uint[] storage _collection, uint _id) public returns(bool _res) {
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
	function removeIndex(uint[] storage _collection, uint _id) public returns(bool _res) {
		uint index = indexOf(_collection, _id);
		if(index != 0 ){
			_collection[index] = 0;
		}
		return true;
	}
}
