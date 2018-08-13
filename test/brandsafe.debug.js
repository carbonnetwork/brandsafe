var Datastore = artifacts.require("Datastore");
//var AnalysisController = artifacts.require("AnalysisController");
var FinanceController = artifacts.require("FinanceController");

//const Web3 = require("web3");
//var web3 = new Web3();

var carbonAddress = '0x808e5ccf00d12e7f13c845da0fb7dd0b8855646a';
//var contractAddress = '0xb264f8eed17098150fc5041cc8562122f7e4db78';

contract("Finance", function(accounts){
/*
	it("it recharge & withdraw in contract", function(){
		var ds;

		Datastore.new(carbonAddress).
		then(datastore => {
			ds = datastore;
			console.log("datastore address: " + ds.address);
			ds.setCaller(accounts[1]);
		}).
		then(function(){ 
			return ds.recharge('300000',{from : accounts[1]})
		}).
		then(p => {
			console.log("recharge hash: " + p.tx);
			return ds.balanceOf.call(accounts[1]);
		}).
		then(b => {
			console.log("balance:" + b);
			return ds.withdraw(accounts[1], b.valueOf());
		}).
		then(p => {
			console.log("recharge hash: " + p.tx);
			return ds.balanceOf.call(accounts[1]);
		}).
		then(b => {
			console.log("balance 2:" + b);
		}).
		catch(err => {
			console.log("get debug result error: " + err);
		});
	});
*/

	it("it recharge & withdraw in contract", function(){
		var an;
		var ds;

		Datastore.new(carbonAddress).
		then(datastore => {
			ds = datastore;
			console.log("datastore address: " + ds.address);
		}).
		then(function(){ return FinanceController.new(ds.address); }).
		then(fin => { 
			console.log("finance address:" + fin.address);
			an = fin;
			ds.setCaller(fin.address,{from : accounts[0]});
		}).
		//FinanceController.at(contractAddress).
		//AnalysisController.at(contractAddress).
		then(function(){ 
			return an.recharge('300000',{from : accounts[1]})
		}).
		then(p => {
			console.log("recharge hash: " + p.tx);
			return an.balance.call({from : accounts[1]});
		}).
		then(b => {
			console.log("balance:" + b);
			return an.withdrawPayments({from : accounts[1]});
		}).
		then(p => {
			console.log("recharge hash: " + p.tx);
			return an.balance.call({from : accounts[1]});
		}).
		then(b => {
			console.log("balance 2:" + b);
		}).
		catch(err => {
			console.log("get debug result error: " + err);
		});
	});

});