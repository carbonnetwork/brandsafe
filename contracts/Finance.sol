pragma solidity ^0.4.23;


import "./Manager.sol";
import "carbon-ico/contracts/SafeMathLib.sol";

/**
 * The Finance contract does this and that...
 */
contract Finance is Manager {
	using SafeMathLib for uint256;

	mapping (address => uint256) public balances;

	event withdraw(address analysor, uint256 _amount);

	function addAmount(address sender, uint256 _amount) public onlyLicensee returns(bool res) {
		require (sender != address(0) && _amount > 0);
		
		balances[sender] = balances[sender].add(_amount);
		return true;
	}

	function subAmount(address analysor, uint256 payment) public onlyLicensee returns(bool res) {	
		require (payment > 0);

    	balances[analysor] = balances[analysor].sub(payment);
    	return true;
	}

	function balanceOf(address analysor) public view returns(uint256 payment) {
		require (analysor != address(0));		

		return balances[analysor];
	}
	
}
