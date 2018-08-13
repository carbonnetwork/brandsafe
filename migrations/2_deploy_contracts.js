//var EtherRouter = artifacts.require("EtherRouter");
var SafeMathLib = artifacts.require("SafeMathLib");
var MapLib = artifacts.require("MapLib");
var StringLib = artifacts.require("StringLib");
var Datastore = artifacts.require("Datastore");
var Lockstore = artifacts.require("Lockstore");
var FinanceController = artifacts.require("FinanceController");
var DemandController = artifacts.require("DemandController");
var AnalysisController = artifacts.require("AnalysisController");

var tokenAddress = '0x55c2cd6cbc22beb2d6894d0f00e08ee9da8c0acf';

module.exports = function(deployer) {
  deployer.deploy(MapLib, {overwrite: false});
  deployer.deploy(StringLib, {overwrite: false});
  deployer.deploy(SafeMathLib, {overwrite: false});
  
  deployer.link(MapLib, Lockstore);
  deployer.link(SafeMathLib, Datastore);
  deployer.link(StringLib, AnalysisController)

  deployer.deploy(Datastore, tokenAddress, {overwrite: false}).
  then(function(){
    deployer.deploy(FinanceController, Datastore.address, {overwrite: false});
    deployer.deploy(DemandController, Datastore.address, {overwrite: false});

    deployer.deploy(Lockstore, {overwrite: false}).
    then(function(){
      deployer.deploy(AnalysisController, Datastore.address, Lockstore.address, {overwrite: false});
    });
  });
};
