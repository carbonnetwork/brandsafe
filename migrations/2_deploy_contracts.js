//var EtherRouter = artifacts.require("EtherRouter");
//var Ownable = artifacts.require("Ownable");
var SafeMathLib = artifacts.require("SafeMathLib");
var Manager = artifacts.require("Manager");
var Finance = artifacts.require("Finance");
var MapLib = artifacts.require("MapLib");
var StringLib = artifacts.require("StringLib");
var Datastore = artifacts.require("Datastore");
var Lockstore = artifacts.require("Lockstore");
var Finance 
var FinanceController = artifacts.require("FinanceController");
var DemandController = artifacts.require("DemandController");
var AnalysisController = artifacts.require("AnalysisController");
var CarbonToken = artifacts.require("CarbonToken");

module.exports = function(deployer) {
  deployer.deploy(MapLib);
  deployer.deploy(StringLib);

  deployer.deploy(SafeMathLib);
  
  deployer.link(SafeMathLib, Datastore);
  deployer.deploy(Datastore, '0x47f097a5b158bbabe5c91ee0e44c8645d4d5eaaf');

  deployer.link(MapLib, Lockstore);
  deployer.deploy(Lockstore);

  //deployer.deploy(FinanceController);
  //deployer.deploy(DemandController);

  deployer.link(StringLib, AnalysisController)
  //deployer.deploy(AnalysisController);
};
