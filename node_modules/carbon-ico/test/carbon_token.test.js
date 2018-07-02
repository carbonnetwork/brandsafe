var CarbonToken = artifacts.require("./CarbonToken.sol");

contract('CarbonToken', function(accounts) {

  it("should put 1 CarbonToken in the fifth account", function() {
    return CarbonToken.deployed().then(carbon => {
      carbon.transfer(accounts[6], 2000);
      return carbon;
    }).
    then(carbon => { return carbon.balanceOf.call(accounts[6]);}).
    then(balance => {
      console.log("the account has " + balance.valueOf()/(10**18) + " token(s)");
      assert.equal(balance.valueOf(), 2000, "1 wasn't in the account");
    }).
    catch(err => {
      console.log("error: " + err);
    });
  });

});