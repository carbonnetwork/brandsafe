// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';
import { default as $} from 'jquery'

// Import our contract artifacts and turn them into usable abstractions.
import datastore_artifacts from '../../build/contracts/Datastore.json';
import lockstore_artifacts from '../../build/contracts/Lockstore.json';
import finance_artifacts from '../../build/contracts/FinanceController.json';
import demand_artifacts from '../../build/contracts/DemandController.json';
import carbon_artifacts from '../../build/contracts/CarbonToken.json';

const tokenAddress = "0x55c2cd6cbc22beb2d6894d0f00e08ee9da8c0acf";
const contractAddress = "0xd09a3ec16f4c4913294b492e7d42720ff490744a";

var Datastore = contract(datastore_artifacts);
var Lockstore = contract(lockstore_artifacts);
var Finance = contract(finance_artifacts);
var Demand = contract(demand_artifacts);
var Carbon = contract(carbon_artifacts);

var accounts;

window.App = {
  // 初始化合约与账户
  init: function() {
   
    Datastore.setProvider(web3.currentProvider);
    Lockstore.setProvider(web3.currentProvider);
    Finance.setProvider(web3.currentProvider);
    Demand.setProvider(web3.currentProvider);
    Carbon.setProvider(web3.currentProvider);

    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
    });
  },

  setCallPermission: function(type){
    var pass =prompt("Please input your password:");
    web3.personal.unlockAccount(accounts[0], pass, 120, function(err,res){
      if(res){
        var act;
        if (type == "Datastore"){
          act = document.getElementById('dsCallAddress').value;

          if(act == ''){
            alert("call address must not be empty");
            return;
          }

          Datastore.deployed().
          then(s => {
            return s.setCaller(act, {from: accounts[0]});
          }).
          then(p => {
            console.log("hash:" + p.tx);
            alert("success, hash:" + p.tx);
          }).
          catch(err => {
            alert("Set call permission error: " + err);
          });
        } 
        else if (type == "Lockstore"){
          act = document.getElementById('lsCallAddress').value;

          if(act == ''){
            alert("call address must not be empty");
            return;
          }

          Lockstore.deployed().
          then(s => {
            return s.setCaller(act, {from: accounts[0]});
          }).
          then(p => {
            console.log("hash:" + p.tx);
            alert("success, hash:" + p.tx);
          }).
          catch(err => {
            alert("Set call permission error: " + err);
          });
        } 
        else {
          alert("Unknown contract.");
        }
      } 
      else {
        alert("password incorrect: " + err);
      }
    });
    
  }, 

  transfer: function(){
    var self = this;
    var from = $('#from').val();
    var to = $('#to').val();
    var amount = $('#tokenAmount').val();

    if(from.length != 42 || to.length != 42){
      alert("account address incorrect");
      return;
    }

    if(amount == ''){
      alert("amount must be not empty");
      return;
    }

    if(isNaN(amount) || parseInt(amount) <=0 ){
      alert("amount must be greate than 0");
      return;
    }

    var pass =prompt("Please input your password:");
    web3.personal.unlockAccount(from, pass, 120, function(err,res){
      if(res){
        Carbon.at(tokenAddress).
        then(t => {
          return t.transfer(to, amount,{from : from});
        }).
        then(p => {
          //console.log("hash:" + p.tx);
          alert("success, hash:" + p.tx);
          self.refreshTokenBalance();
        }).
        catch(err => {
          alert("transfer failed:" + err);
        });
      }else{
        alert("password incorrect: " + err);
      }
    });
  },

  recharge: function(){
    var self = this;
    var addr = $('#recharge').val();

    if(addr.length != 42){
      alert("account address incorrect");
      return;
    }

    var amount = $('#amount').val();

    if(amount == ''){
      alert("amount must be not empty");
      return;
    }

    if(isNaN(amount) || parseInt(amount) <=0 ){
      alert("amount must be greate than 0");
      return;
    }

    var pass =prompt("Please input your password:");
    web3.personal.unlockAccount(addr, pass, 120, function(err,res){
      if(res){
        Finance.deployed().
        then(f => {
         return f.recharge(parseInt(amount), {from: addr});
        }).
        then(p =>{ 
          alert("success, hash:" + p.tx);
          self.refreshTokenBalance();
          self.refreshBalance(); 
        }).
        catch(err => {
          alert("recharge failed:" + err);
        });
      }else{
        alert("password incorrect: " + err);
      }
    });
  },

  withdraw: function(){
    var self = this;

    var addr = $('#withdraw').val();

    if(addr.length != 42){
      alert("account address incorrect");
      return;
    }

    var pass =prompt("Please input your password:");
    web3.personal.unlockAccount(addr, pass, 120, function(err,res){
      if(res){
        Finance.deployed().
        then(f => {
          return f.withdrawPayments({from: addr});
        }).
        then(p => { 
          alert("success, hash:" + p.tx);
          self.refreshTokenBalance();
          self.refreshBalance(); 
        }).
        catch(err => {
          alert("withdraw failed:" + err);
        });
      }else{
        alert("password incorrect:" + err);
      }
    });
  },

  refreshBalance : function(){
    $('#balance').empty();

    Finance.deployed().
    then(f => {

      $.each(accounts, function(i, acc){
        f.balance.call({from: acc}).
        then(b => {
          $('#balance').append($('<span />').text(acc + ':  ' + new Number(b.valueOf()).toLocaleString())).append('<br>');
        }).
        catch(err => {
          console.log('error:' + err)
          $('#balance').append($('<span />').text(acc + ': error')).append('<br />');
        });
      });        
    });
  },

  refreshTokenBalance: function(){
    $('#tokenBalance').empty();

    Carbon.at(tokenAddress).
    then(t => {
      var accts = [];
      accts.push(accounts[0],accounts[1],accounts[2],contractAddress);

      $.each(accts, function(i,acc){
        t.balanceOf.call(acc).
        then(b => {
          $('#tokenBalance').append($('<span />').text(acc + ':  ' + b.valueOf())).append('<br />');
        }).
        catch(err => {
          console.log('error:' + err)
          $('#tokenBalance').append($('<span />').text(acc + ': error')).append('<br />');
        });
      });
    });
  },

  add: function(){
    var self = this;
    var url = $('#addurl').val();

    var pass =prompt("Please input your password:");
    web3.personal.unlockAccount(accounts[1], pass, 120, function(err,res){
      if(res){
        Demand.deployed().
        then(d => {
          return d.addURL(url, 1000, {from: accounts[1], gas: 1000000});
        }).
        then(p => {
          alert("success, hash:" + p.tx);
          self.refreshBalance();
        }).catch(err => {
          alert("add url failed:" + err);
        });  
      }else{
        alert("password incorrect:" + err);
      }
    });
  },

  query: function(){
    var url = $('#url').val();

    Demand.deployed().
    then(d => {
      return d.query.call(url, {from: accounts[1]});
    }).
    then(res => {
      $('#cates').text(web3.toAscii(res.valueOf()));
    }).catch(err => {
      $('#cates').text(err);
    });
  }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
  }

  App.init();
});
