var SafeMathLib = artifacts.require("./SafeMathLib.sol");
var Ownable = artifacts.require("./Ownable.sol");
var ERC20 = artifacts.require("./ERC20.sol");
var StandardToken = artifacts.require("./StandardToken.sol");
var CarbonToken = artifacts.require("./CarbonToken.sol");
var CarbonTokenMock = artifacts.require("./test/CarbonTokenMock.sol"); 

module.exports = function(deployer) {
  deployer.deploy(SafeMathLib);
  deployer.deploy(Ownable);
  //deployer.deploy(ERC20); //abstract contract or interface has no bytecode, don't need deploy.
  deployer.link(SafeMathLib, [StandardToken,CarbonToken]);
  deployer.deploy(StandardToken);
  deployer.deploy(CarbonToken).then(function(){
  	return deployer.deploy(CarbonTokenMock, CarbonToken.address);
  });
};