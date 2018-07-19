pragma solidity ^0.4.23;

import "carbon-ico/contracts/Ownable.sol";

import "./Index.sol";

import "./Finance.sol";




/**
 * The Datastore contract does this and that...
 */
contract Datastore is Finance,Index {

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

	constructor() public {
		
	}
	
	function insertURL (bytes _url,uint256 _price, address _sender) public onlyLicensee returns(bool res) {
		require (_url.length > 0 && _price > 0);

		URL memory url = URL({
			sender : _sender,
			url : _url,
			price : _price,
			status : 0,
			timestamp : now,
			analysor : address(0),
			cates : '',
			gas : 0,
			exist : 1
		});

		urls[++id] = url;

		addStatusIndex(0, id);
		addUrlIndex(_sender, _url, id);

		return true;
	}

	function getId() public view returns(uint res) {
		return id;
	}	

	function setAnalysor (uint _id, address _analysor) public onlyLicensee returns(bool res) {
		require (_id > 0);	
		require (_analysor != address(0));

		if(urls[_id].exist == 0){
			return false;
		}

		URL storage u = urls[_id];
		u.analysor = _analysor;
		return true;
	}
	
	function getAnalysor (uint _id) public view returns(address _analysor) {
		require (_id > 0);

		if(urls[_id].exist == 0){
			return address(0);
		}
		return urls[_id].analysor;
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
			

	function changeStatus(uint8 _status, uint _id) public onlyLicensee returns(bool res) {
		require (_id > 0);
		
		if(urls[_id].exist == 0){
			return false;
		}

		URL storage u = urls[id];
		uint[] storage ids = statusIndex[u.status];
		//removeIndex(ids, _id);

		u.status = _status;
		ids = statusIndex[_status];
		addIndex(ids, _id);
		return true;
	}
	
	
	function getStatusByID (uint _id) public view returns(uint8 _status) {
		require (_id > 0);
		
		if(urls[_id].exist != 0){
			return urls[_id].status;
		}

		return 0;
	}
	
	function getURLByID (uint _id) public view returns(bytes _url, address _sender, uint256 _price, uint8 _status)  {
		require (_id > 0);
		
		if(urls[_id].exist != 0){
			URL storage u = urls[_id];
			return (u.url, u.sender, u.price, u.status);
		}
		
		return ("", address(0), 0, 0);
	}

	function getCates (address _sender, bytes _url) public view returns(bytes _cates) {
		require (_url.length > 0);
		require (_sender != address(0));

		uint _id = getIndexByUrl(_sender, _url);
		if(urls[_id].exist != 0){
			URL storage u = urls[_id];
			return u.cates;
		}
		return "";
	}						
}
