// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them into usable abstractions.
import datastore_artifacts from '../../build/contracts/Datastore.json';
import lockstore_artifacts from '../../build/contracts/Lockstore.json';
import finance_artifacts from '../../build/contracts/FinanceController.json';
import demand_artifacts from '../../build/contracts/DemandController.json';

var Datastore = contract(datastore_artifacts);
var Lockstore = contract(lockstore_artifacts);
var Finance = contract(finance_artifacts);
var Demand = contract(demand_artifacts);

var accounts;

window.App = {
  // 初始化合约与账户
  init: function() {
   
    Datastore.setProvider(web3.currentProvider);
    Lockstore.setProvider(web3.currentProvider);
    Finance.setProvider(web3.currentProvider);
    Demand.setProvider(web3.currentProvider);

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
    var act;
    if (type == "Datastore"){
      act = document.getElementById('dsCallAddress').value;

      if(act == ''){
        alert("调用的地址不能为空");
        return;
      }

      Datastore.deployed().
      then(s => {
        s.setCaller(accounts[0]);
      }).
      catch(err => {
        alert("Set call permission error: " + err);
      });
    } 
    else if (type == "Lockstore"){
      act = document.getElementById('lsCallAddress').value;

      if(act == ''){
        alert("调用的地址不能为空");
        return;
      }

      Lockstore.deployed().
      then(s => {
        s.setCaller(accounts[0]);
      }).catch(err => {
        alert(Set call permission error: " + err);
      });
    } 
    else {
      alert("Unknown contract.");
    }
  }, 

  recharge : function(){
    var amount = document.getElementById('amount').value;

    if(amount == ''){
      alert("要充值的额度不能为空");
      return;
    }

    if(isNaN(amount) || parseInt(amount) <=0 ){
      alert("要充值的额度必须是大于0的数字");
      return;
    }

    Finance.deployed().
    then(f => {
      f.recharge(parseInt(amount));
    }).
    then(function(){ this.refreshBalance(); }).
    catch(err => {
      alert("充值失败:" + err);
    });
  },

  withdraw : function(){
    Finance.deployed().
    then(f => {
      f.withdraw();
    }).
    then(function(){ this.refreshBalance(); }).
    catch(err => {
      alert("提取token失败:" + err);
    });
  },

  refreshBalance : function(){
    Finance.deployed().
    then(f => {
      return f.balance.call();
    }).
    then(b => {
      document.getElementById('balance').innerText = b.valueOf();
    }).
    catch(err => {
      //alert("提取token失败:" + err);
      document.getElementById('balance').innerText = err;
    });
  },

  query : function(){
    var url = document.getElementById('url').value;

    Finance.deployed().
    then(f => {
      return f.query.call(url);
    }).
    then(res => {
      document.getElementById('cates').innerText = res.valueOf();
    }).catch(err => {
      //alert("提取token失败:" + err);
      document.getElementById('cates').innerText = err;
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
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:9545"));
  }

  App.init();
});
