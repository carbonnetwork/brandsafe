//var EtherRouter = artifacts.require("./ether-router/EtherRouter.sol");
//var Ownable = artifacts.require("carbon-ico/contracts/Ownable.sol");
var SafeMathLib = artifacts.require("carbon-ico/contracts/SafeMathLib.sol");
var Manager = artifacts.require("./Manager.sol");
var Finance = artifacts.require("./Finance.sol");
var MapLib = artifacts.require("./lib/MapLib.sol");
var StringLib = artifacts.require("./lib/StringLib.sol");
var ArraysLib = artifacts.require("./lib/ArraysLib.sol");
var Datastore = artifacts.require("./Datastore.sol");
var Lockstore = artifacts.require("./Lockstore.sol");
var AdminController = artifacts.require("./AdminController.sol");
var DemandController = artifacts.require("./DemandController.sol");
var AnalysisController = artifacts.require("./AnalysisController.sol");

module.exports = function(deployer) {
  deployer.deploy(MapLib);
  deployer.deploy(StringLib);
  deployer.deploy(ArraysLib);
  //deployer.deploy(Manager);

  deployer.deploy(SafeMathLib);
  //deployer.link(SafeMathLib, [Finance,Datastore]);
  //deployer.deploy(Finance);
  
  deployer.link(SafeMathLib, Datastore);
  deployer.link(ArraysLib, Datastore);
  deployer.deploy(Datastore);

  deployer.link(MapLib, Lockstore);
  deployer.deploy(Lockstore);

  //deployer.deploy(AdminController);
  //deployer.deploy(DemandController);

  deployer.link(StringLib, AnalysisController)
  //deployer.deploy(AnalysisController);
};
