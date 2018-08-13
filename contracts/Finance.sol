pragma solidity ^0.4.23;


import "./Manager.sol";
import "carbon-ico/contracts/SafeMathLib.sol";

import "carbon-ico/contracts/CarbonToken.sol";


/**
 * The Finance contract does this and that...
 */
contract Finance is Manager {
	using SafeMathLib for uint256;

	CarbonToken token;

	mapping (address => uint256) public balances;

	constructor(address tokenAddress) public{
		token = CarbonToken(tokenAddress);
	}

	function addAmount(address sender, uint256 _amount) internal returns(bool res) {
			
		balances[sender] = balances[sender].add(_amount);
		return true;
	}

	function subAmount(address analysor, uint256 payment) internal returns(bool res) {	

    	balances[analysor] = balances[analysor].sub(payment);
    	return true;
	}
	
	function balanceOf(address analysor) public view returns(uint256 payment) {
		require (analysor != address(0));		

		return balances[analysor];
	}


	function recharge (uint256 _amount) public onlyLicensee returns(bool res) {
		require (_amount > 0);
		
		address u = address(this);
		token.recharge(u, _amount);
		addAmount(tx.origin, _amount);

		return true;
	}
	
	function withdraw (address analysor, uint256 _amount) public onlyLicensee returns(bool res) {
		require (analysor != address(0) && _amount > 0);

		subAmount(analysor, _amount);
		token.transfer(analysor, _amount);
		return true;
	}
	
	function asyncSend(address _from, address _to, uint256 _amount) public {		
		subAmount(_from, _amount);
	    addAmount(_to, _amount);
	}
}
