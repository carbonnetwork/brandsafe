var CarbonToken = artifacts.require("./CarbonToken.sol");

contract('CarbonToken', function(accounts) {

  it("should put 1 CarbonToken in the second account", function() {
    return CarbonToken.deployed().then(function(instance) {
      return instance.transfer(accounts[1], 100000 , {from : accounts[0], gas : 6000000});
    }).then(function(balance) {
      //assert.equal(balance.valueOf(), 10**18, "1 wasn't in the first account");
    });
  });
});