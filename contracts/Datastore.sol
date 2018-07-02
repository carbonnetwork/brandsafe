pragma solidity ^0.4.23;

import "carbon-ico/contracts/Ownable.sol";

import "./lib/MapLib.sol";
import "./lib/ArraysLib.sol";
import "./lib/StringLib.sol";


import "./Finance.sol";




/**
 * The Datastore contract does this and that...
 */
contract Datastore is Finance {
	using SafeMathLib for uint256;
	using StringLib for bytes;
	using ArraysLib for uint[];

	struct URL {
		address sender;
		uint256 price;
		address analysor;
		bytes url;
		bytes cates;
		uint8 status; // 0 new, 1 in progress, 2 complete
		uint gas;
		uint timestamp;
		uint8 exist;
	}
	
	uint id;
	
	mapping (uint => URL) urls;
	
	mapping (uint8 => uint[]) statusIndex;

	/*
	//用于按日期组织内容，以方便清理旧的数据，留作扩展
	mapping (bytes => uint[]) dateIndex;

	//用于按发送url的地址建立索引，方便其查询自己的数据，留作扩展
	mapping (address => uint[]) senderIndex;
	
	//用于按分析url的地址建立索引，方便期查询记录，留作扩展
	mapping (address => uint[]) analysorIndex;
	*/
	
	constructor() public {
		
	}
	
	function insertURL (bytes _url,uint256 _price) public onlyLicensee returns(uint _id) {
		require (_url.length > 0 && _price > 0);

		URL memory url = URL({
			sender : msg.sender,
			url : _url,
			price : _price,
			status : 0,
			timestamp : now,
			analysor : address(0),
			cates : '',
			gas : 0,
			exist : 1
		});

		_id = id++;
		urls[_id] = url;

		addStatusIndex(0, id);

		return;
	}

	function setResult (uint _id, bytes _cates, address _analysor) public onlyLicensee returns(bool res) {		
		require (_id > 0);
		require (_cates.length > 0);	
		require (_analysor != address(0));
		
		if(urls[_id].exist == 0){
			return false;
		}

		URL storage u = urls[_id];
		u.analysor = _analysor;
		u.cates = _cates;

		return true;
	}
			

	function addStatusIndex (uint8 _status, uint _id) public onlyLicensee returns(bool res) {
		require (_status < 3);
		
		uint[] storage ids = statusIndex[_status];
		ids.addIndex(_id);
		return true;
	}


	function getIndexByStatus(uint8 _status) public view returns(uint[] res) {
		require (_status < 3);

		return statusIndex[_status];
	}

	function changeStatus(uint8 _status, uint _id) public onlyLicensee returns(bool res) {
		require (_id > 0);
		
		if(urls[_id].exist == 0){
			return false;
		}

		URL storage u = urls[id];
		uint[] storage ids = statusIndex[u.status];
		ids.removeIndex(_id);

		u.status = _status;
		ids = statusIndex[_status];
		ids.addIndex(_id);
		return true;
	}
	
	
	function getStatusByID (uint _id) public view returns(uint8 _status) {
		require (_id > 0);
		
		if(urls[_id].exist != 0){
			return urls[_id].status;
		}

		return 0;
	}
	
	function getURLByID (uint _id) public view returns(bytes _url, address _sender, uint256 _price )  {
		require (_id > 0);
		
		if(urls[_id].exist != 0){
			URL storage u = urls[_id];
			return (u.url, u.sender, u.price);
		}
		
		return ("", address(0), 0);
	}
							
}
