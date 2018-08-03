var Datastore = artifacts.require("./Datastore.sol");
var Lockstore = artifacts.require("./Lockstore.sol");

var DemandController = artifacts.require("./DemandController.sol");
var AnalysisController = artifacts.require("./AnalysisController.sol");

const Web3 = require("web3");
var web3 = new Web3();

var carbonAddress = '0x94e1529a98c18e65a235f3a442aad9176788f5c1';

var url = 'https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_12818995968293311098%22%7D&n_type=0&p_from=1';

contract("BrandSafe", function(accounts){
	it("it should add a url in contract", function(){
		var ls;
		var ds;
		var dm;
		var an;

		var _res;

		Lockstore.new().then(lockstore => {
			ls = lockstore;
		});

		Datastore.new(carbonAddress).
		then(datastore => {
			ds = datastore;
		}).
		then(function(){ return DemandController.new(ds.address); }).
		then(demand => { 
			console.log("demand address:" + demand.address);

			dm = demand;
			ds.setCaller(demand.address);

			ds.setCaller(accounts[1]);//
			//return ds;
		}).
		then(demand => {
			console.log("1th accounts: " + accounts[1]);
			return ds.recharge(10**15, {from : accounts[1]});
			//return ds;
		}).
		then(p =>{
			console.log("transaction id:" + p.tx);
		}).
		then(function(){ return ds.balanceOf(accounts[1]);}).
		then(b => { console.log("brand safe balance:" + b.valueOf()); }).
		then(function(){ return AnalysisController.new(ds.address,ls.address)}).
		then(analysis => { 
			console.log("analysis address:" + analysis.address);
			an = analysis;
			ds.setCaller(analysis.address);
			ls.setCaller(analysis.address); 
			//return ds;
		}).
		then(function(){ return ds.balanceOf.call(accounts[1]); }).
		then(b => {console.log("account " + accounts[1] + " balance is: " + b.valueOf()); }).
		/*then(function(){
			return dm.addURL(url,1000,{from: accounts[1]});
		}).
		then(function(p){
			console.log("transaction id:" + p.tx);
			//logObject(p,0);
		}).
		*/
		/*
		then(function(){ return ds.getId.call(); }).
		then(id => {
			console.log("id:" + id.valueOf());
			return ds.getURLByID.call(id.valueOf()); 
		}).
		then(res => { console.log("ds res:" + res.valueOf());}).
		*/

		/*then(function() { return an.getURL.call({from: accounts[2]}); }).
		then(res => {
			console.log("res: " + res.valueOf());
			_res = res;
			assert.equal(web3.toAscii(res[1]),url,"url not equal");
			return an.lockUrl(res[0],{from: accounts[2]});
		}).
		then(res => { logObject(res, 0); }).
		*/
		/*
		then(function() { return an.getURL.call(); }).
		then(res => {
			console.log("res 2: " + res.valueOf());
			return an.lockUrl(res[0],{from: accounts[3]});
		}).
		then(res => { logObject(res, 0); }).
		*/
		/*
		then(function(){ return an.fillCates(_res[0], web3.toAscii(_res[1]), "game,science,edu,economic,affairs", {from: accounts[2]}); }).
		then(p => { logObject(p, 0); }).
		then(function(){ return dm.query.call(web3.toAscii(_res[1]), {from: accounts[1]}); }).
		//then(p => logObject(p, 0)).
		then(res => {
			console.log("query res: " + web3.toAscii(res));
		}).*/
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