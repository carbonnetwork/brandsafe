var Lockstore = artifacts.require("./Lockstore.sol");

contract.skip("Lockstore", function(accounts){

	it("it should store a url to Lockstore", function(){
		var ls;
		var index;

		Lockstore.new().
		then(function(lockstore){
			ls = lockstore;
			return ls;
		}).
		then(ls => { ls.put(accounts[0], 1); }).
		then(pe => { logObject(pe, 0); }).
		then(function(){
			return ls.getID.call(accounts[0]);
		}).
		then(p => { 
			console.log("id: " + p.valueOf());
			assert.equal(p.valueOf(), 1, "not equal")
		}).
		then(function(){ return ls.put(accounts[1],2 ); }).
		then(pe => { logObject(pe, 0); }).
		then(function(){ return ls.put(accounts[2],3 ); }).
		then(pe => { logObject(pe, 0); }).
		then(function(){ return ls.start.call() }).
		then(idx => {
			index = idx.valueOf();
			console.log("index value: " + index);
			return ls.get(index); 
		}).
		then(res => {
			console.log("res1: " + res);
			return ls.next.call(index);
		}).
		then(idx => {
			index = idx.valueOf();
			console.log("index value: " + index);
			return ls.get(index); 
		}).
		then(res => {
			console.log("res2: " + res);
			return ls.next.call(index);
		}).
		then(idx => {
			index = idx.valueOf();
			console.log("index value: " + index);
			return ls.get(index); 
		}).
		then(res => {
			console.log("res3: " + res);
			//return ls.get.call(0);
		}).
		catch(err => {
			console.log("error: " + err );
		});
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