var SafeMathLib = artifacts.require("./SafeMathLib.sol");
var Ownable = artifacts.require("./Ownable.sol");
var ERC20 = artifacts.require("./ERC20.sol");
var StandardToken = artifacts.require("./StandardToken.sol");
var CarbonToken = artifacts.require("./CarbonToken.sol");
//var CarbonTokenMock = artifacts.require("./test/CarbonTokenMock.sol"); 

module.exports = function(deployer) {
  deployer.deploy(SafeMathLib);
  deployer.deploy(Ownable);
  deployer.deploy(ERC20);
  deployer.link(SafeMathLib, StandardToken);
  deployer.link(SafeMathLib, CarbonToken)
  deployer.deploy(StandardToken);
  deployer.deploy(CarbonToken);
  //deployer.deploy(CarbonTokenMock, "0x488e9658bae7d527fc3a9303074e5ae05934c772",
  //{from : "0x627306090abab3a6e1400e9345bc60c78a8bef57", gas : 1000000});
};