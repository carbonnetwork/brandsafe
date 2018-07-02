pragma solidity ^0.4.23;

import "carbon-ico/contracts/Ownable.sol";

/**
 * The Manager contract does this and that...
 */
contract Manager is Ownable {

	mapping (address => uint8) callers;

	modifier onlyLicensee() { 
		require (callers[msg.sender] == 1); 
		_; 
	}
	
	function setCaller (address _caller) public onlyOwner returns(bool res)  {	
		require (_caller != address(0));
		callers[_caller] = 1;
		return true;
	}

	function removeCaller (address _caller) public onlyOwner returns(bool res) {
		require (_caller != address(0));
		delete callers[_caller];
		return true;
	}
			
}
