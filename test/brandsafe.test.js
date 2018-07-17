var Datastore = artifacts.require("./Datastore.sol");
var Lockstore = artifacts.require("./Lockstore.sol");

var DemandController = artifacts.require("./DemandController.sol");
var AnalysisController = artifacts.require("./AnalysisController.sol");

const Web3 = require("web3");
var web3 = new Web3();

contract("BrandSafe", function(accounts){
	it("it should add a url in contract", function(){
		var ls;
		var ds;
		var dm;
		var an;

		Lockstore.new().then(lockstore => {
			ls = Lockstore;
		});

		Datastore.new().
		then(datastore => {
			ds = datastore;
		}).
		then(function(){ return DemandController.new(ds.address); }).
		then(demand => { 
			dm = demand;
			ds.setCaller(demand.address);
			//return ds;
		}).
		then(demand => {
			ds.addAmount(accounts[1], 10**15);
			return ds;
		}).
		then(function(){ return AnalysisController.new(ds.address,ls.address)}).
		then(analysis => { 
			an = analysis;
			ds.setCaller(analysis.address); 
			return ds;
		}).
		then(ds => {return ds.balanceOf.call(accounts[1]);}).
		then(b => {console.log("account " + accounts[1] + " balance is: " + b.valueOf()); }).
		then(function(){
			console.log("is this can execute");
			return dm.addURL("https://github.com/trufflesuite/truffle/issues/1050",1000,{from: accounts[1]});
		}).
		then(function(p){
			logObject(p,0);
		}).
		/*
		then(function(){ return ds.getId.call(); }).
		then(id => {
			console.log("id:" + id.valueOf());
			return ds.getURLByID.call(id.valueOf()); 
		}).
		then(res => { console.log("ds res:" + res.valueOf());}).
		*/
		then(function() { return an.getURL.call(); }).
		then(res => {
			console.log("res: " + res.valueOf());
			assert.equal(web3.toAscii(res[1]),"https://github.com/trufflesuite/truffle/issues/1050","url not equal");
			return an.lockUrl(res[0],{from: accounts[2]});
		}).

		then(res => { logObject(res, 0); }).
		then(function() { return an.getURL.call(); }).
		then(res => {
			console.log("res 2: " + res.valueOf());
			return an.lockUrl(res[0],{from: accounts[3]});
		}).
		then(res => { logObject(res, 0); }).
		catch(err => { console.log("execute error:" + err); });
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