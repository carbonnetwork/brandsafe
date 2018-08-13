pragma solidity ^0.4.23;


import "./Manager.sol";


/**
  * The index contract does this and that...
  */
 contract Index is Manager {

 	mapping (uint8 => uint[]) statusIndex;

 	mapping (address => mapping (bytes => uint)) urlIndex;
	

	/*
	//用于按日期组织内容，以方便清理旧的数据，留作扩展
	mapping (bytes => uint[]) dateIndex;

	//用于按发送url的地址建立索引，方便其查询自己的数据，留作扩展
	mapping (address => uint[]) senderIndex;
	
	//用于按分析url的地址建立索引，方便期查询记录，留作扩展
	mapping (address => uint[]) analysorIndex;
	*/

 	constructor() public{

 	}

 	function addUrlIndex (address _sender, bytes _url, uint _id) public onlyLicensee returns(bool res) {
 		require (_sender != address(0));
 		require (_url.length > 0 && _id > 0);
 		
 		mapping (bytes => uint) idx = urlIndex[_sender];
 		idx[_url] = _id;

 		return true;
 	}
 	

 	function getIndexByUrl (address _sender, bytes _url) public view returns(uint _id) {
 		require (_sender != address(0));
 		require (_url.length > 0);

 		mapping (bytes => uint) idx = urlIndex[_sender];
 		return idx[_url];
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
		_collection[index] = 0;
		return true;
	}
}
