const Web3 = require('web3');
var Datastore = artifacts.require("Datastore");
var CarbonToken = artifacts.require("CarbonToken");
var web3 = new Web3();

var url = "http://solidity-cn.readthedocs.io/zh/develop/metadata.html";

var carbonAddress = '0xcd8d3b6c1c9190513a81c88538804def313ed21e';

contract.skip("Datastore",function(accounts){
	it("it should recharge and withdraw", function(){
		var ds;
		var carbon;

		CarbonToken.at(carbonAddress).
		then(cb => {
			carbon = cb;
		});
	
		Datastore.new(carbonAddress).
		then(function(_ds){
			ds = _ds;
			ds.setCaller(accounts[1]);
		}).
		then(function(){ return ds.balanceOf.call(ds.address, {from : accounts[1]}); } ).
		then(res => { console.log(" contract balance 0 is: " + res.valueOf()); }).

		then(function(){ return carbon.balanceOf.call(accounts[1]); } ).
		then(res => { console.log(" accounts[1] balance 0 is: " + res.valueOf()); }).
		then(function() {
			ds.recharge(10 * 10**15, {from : accounts[1]});
		}).
		//then(p => { logObject(p, 0); }).
		then(function(){ return ds.balanceOf.call(ds.address, {from : accounts[1]}); } ).
		then(res => { console.log(" contract balance 1 is: " + res.valueOf()); }).

		then(function(){ return carbon.balanceOf.call(accounts[1]); } ).
		then(res => { console.log(" accounts[1] balance 1 is: " + res.valueOf()); }).
		then(function(){ return ds.withdraw(accounts[1], 5 * 10**15); }).
		//then(p => { logObject(p, 0); }).
		then(function(){ return ds.balanceOf.call(ds.address, {from : accounts[1]}); } ).
		then(res => { console.log(" contract balance 2 is: " + res.valueOf()); }).

		then(function(){ return carbon.balanceOf.call(accounts[1]); } ).
		then(res => { console.log(" accounts[1] balance 2 is: " + res.valueOf()); }).
		catch(err => { console.log("error: " + err); });
	});

	
	it("it should add a url in contract",function(){
		var ds;

		Datastore.new(carbonAddress).
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

		Datastore.new(carbonAddress).
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
		var ds;

		Datastore.new(carbonAddress).
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