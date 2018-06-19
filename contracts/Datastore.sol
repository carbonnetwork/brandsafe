pragma solidity ^0.4.23;

import "carbon-ico/contracts/SafeMathLib.sol";
import "carbon-ico/contracts/CarbonToken.sol";
import "carbon-ico/contracts/Ownable.sol";

import "./lib/MapLib.sol";

/**
 * The Datastore contract does this and that...
 */
contract Datastore is Ownable {
	using MapLib for MapLib.LockMap;
	MapLib.LockMap lockMap;

	using SafeMathLib for uint;

	struct URL {
		address sender;
		uint price;
		address analysor;
		bytes url;
		bytes cates;
		uint8 status; // 0 new, 1 in progress, 2 complete
		uint gas;
		uint timestamp;
	}

	uint constant fiveMin = 5 * 60;
	
	uint id;

	mapping (address => uint256) balances;
	
	mapping (uint => URL) urls;
	
	mapping (uint8 => uint[]) statusIndex;

	CarbonToken carbon;

	/*
	//用于按日期组织内容，以方便清理旧的数据，留作扩展
	mapping (bytes => uint[]) dateIndex;

	//用于按发送url的地址建立索引，方便其查询自己的数据，留作扩展
	mapping (address => uint[]) senderIndex;
	
	//用于按分析url的地址建立索引，方便期查询记录，留作扩展
	mapping (address => uint[]) analysorIndex;
	*/
	
	constructor(address tokenAddress) public {
		carbon = CarbonToken(tokenAddress);
	}
	
	/*
	 * 添加新的url
	 */
	function addURL(bytes _url, uint _price) public returns(bool res) {
		require (_url.length > 0 && _price > 0);
		
		URL memory url = URL({
			sender : msg.sender,
			url : _url,
			price : _price,
			status : 0,
			timestamp : now,
			analysor : address(0),
			cates : '',
			gas : 0
		});

		urls[id++] = url;

		addIndex(statusIndex[0], id);

		//carbon.transfer(owner, _price);
		//balances[msg.sender] += _price;

		return true;
	}


	/*
	 * 获取url中的一个，首先从超时未处理的部分获取;
	 */
	function getURL() public returns(uint _id, bytes _url) {
		if (lockMap.contains()){
			return (0, "");
		}

		uint index = lockMap.iterateStart();
		address key;
		uint timestamp;	
		while (index >= 0){
			(key, _id, timestamp) = lockMap.iterateGet(index);
			if ( _id > 0 && now > timestamp + fiveMin){
				URL storage u = urls[_id];

				if (balances[u.sender] >= u.price){
					lockMap.remove(key);
					return (_id, u.url);
				}				
			}

			index = lockMap.iterateNext(index);
		}

		return getURLByStatus(0);
	}
	

	/*
	 * 根据状态获取url和其对应的额id，目前只获取当前状态的第一条
	 */
	function getURLByStatus(uint8 _status) public view returns(uint uid, bytes url) {
		require (_status < 3);

		uint[] storage ns = statusIndex[0];

		uint length = ns.length;
		for( uint i = 0; i < length; i++){
			uint _id = ns[i];
			URL storage u = urls[_id];
			if (balances[u.sender] >= u.price){
				return (_id, u.url);
			}
		}

		return (0, "");
	}
	
	/*
	 * 将url的状态从未分析，更新为正在分析的状态，更新成功的话，此用户才分析的结果才会有奖励
	 */
	function lockUrl(uint _id) public returns(bool res) {		
		require (_id > 0);

		if (lockMap.contains()){
			return false;
		}
		
		URL storage u = urls[_id];
		if(u.status == 0){
			return false;
		}

		if (balances[u.sender] >= u.price){
			return false;
		}

		removeIndex(statusIndex[0], _id);
		addIndex(statusIndex[1], _id);
		u.status = 0;

		lockMap.put(_id);

		return true;
	}

	/*
	 * 记录url的类别
	 */	
	function fillCates (uint _id, bytes _url, bytes _cates) public returns(bool res) {
	 	require (_id > 0 && _cates.length > 0);
	 	
	 	if(lockMap.get() != _id){
	 		return false;
	 	}

	 	URL storage u = urls[_id];
	 	if(bytesEquals(_url, u.url)){
	 		u.cates = _cates;
	 		u.analysor = msg.sender;
	 		if (u.status == 1) {
	 			removeIndex(statusIndex[1], _id);
	 			addIndex(statusIndex[2], _id);
	 			u.status = 2;
	 		}
	 		
	 		asyncSend(u.sender, msg.sender, u.price);
	 	}

	 	return true;
	}

	function recharge (uint _amount) public {
		require (_amount > 0);
		require (carbon.balanceOf(msg.sender) > _amount);
		
		carbon.transferFrom(msg.sender, address(this), _amount);
		balances[msg.sender] = balances[msg.sender].add(_amount);
	}
	

	function withdrawPayments() public {
	    uint payment = balances[msg.sender];

	    require(payment > 0);
	    require(carbon.balanceOf(address(this)) >= payment);

	    carbon.transferFrom(address(this), msg.sender, payment);
	    balances[msg.sender] = balances[msg.sender].sub(payment);
	}

	function asyncSend(address _from, address _to, uint _amount) internal {

		require (msg.value > 0);

		balances[_from] = balances[_from].sub(_amount);
	    balances[_to] = balances[_to].add(_amount);
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

	function bytesEquals (bytes a, bytes b) internal pure returns(bool res) {
		if( a.length == b.length){
			return false;
		}

		for(uint i=0; i < a.length; i++){
			if(a[i] != b[i]){
				return false;
			}
		}
		return true;
	}
	
}
