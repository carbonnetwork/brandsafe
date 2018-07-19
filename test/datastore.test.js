const Web3 = require('web3');
var Datastore = artifacts.require("./Datastore.sol");
var web3 = new Web3();

var url = "http://solidity-cn.readthedocs.io/zh/develop/metadata.html";

contract.skip("Datastore",function(accounts){

	it("it should add a url in contract",function(){
		var ds;

		Datastore.new().
		then( _ds => { ds = _ds; }).
		then(function(){
			return ds.insertURL(url,1000,accounts[1]);
		}).
		then(p => { logObject(p, 0); }).
		then(function(){ return ds.getId.call()}).
		then(id => {
			console.log("id value: " + id.valueOf());
			return ds.getURLByID.call(id.valueOf());
		}).
		then(res => {
			console.log("res:" + res);
			assert.equal(url, web3.toAscii(res[0]), "url not equal");
		}).
		//then(p => { logObject(p, 0); }).
		catch(err => { console.log("error: " + err); });
	});

	it("it should add status index", function(){
		var ds;

		Datastore.new().
		then(_ds => { ds = _ds;}).
		then(function(){ return ds.addStatusIndex(0,1); }).
		then(p => logObject(p, 0)).
		then(function(){
			ds.addStatusIndex(0,2);
			ds.addStatusIndex(1,3);
			ds.addStatusIndex(1,5);
			ds.addStatusIndex(2,6);
			ds.addStatusIndex(2,4);
		}).
		then(function(){ return ds.getIndexByStatus.call(0); }).
		then(res => {
			console.log("res 0:" + res);
		}).
		then(function(){ return ds.getIndexByStatus.call(1); }).
		then(res => {
			console.log("res 1:" + res);
		}).
		then(function(){ return ds.getIndexByStatus.call(2); }).
		then(res => {
			console.log("res 2:" + res);
		}).catch(err => { console.log("error: " + err); });
	});

	it("it should add url index", function(){
		var url = "https://github.com/trufflesuite/truffle/issues/1050";
		var ds;

		Datastore.new().
		then(_ds => { ds = _ds;}).
		then(function(){ return ds.addUrlIndex(accounts[1], url, 1); }).
		then(p => logObject(p, 0)).
		then(function(){ return ds.getIndexByUrl.call(accounts[1], url); }).
		then(res => {
			console.log("url index res:" + res.valueOf());
			assert.equal(res.valueOf(), 1, "value not equal");
		}).
		catch(err => { console.log("error: " + error); });
	});

	function repeatTab(level) {
		var res = "";
		for(var i = 0; i < level; i++){
			res += "\t";
		}
		return res;
	}

	function logObject (obj, level){
		for(var f in obj){
			console.log(repeatTab(level) + f + ": " + obj[f]);
			if(typeof obj[f] == 'object'){
				var l = level + 1;
				logObject(obj[f], l);
			}
		}
	}

});