pragma solidity ^0.4.23;


import "../CarbonToken.sol";


/**
 * 
 */
contract CarbonTokenMock {
	function transferMock (address tokenAddress, address _to, uint _amout) public {
		uint r;
		bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));

		assembly {
		  mstore(mload(0x40), sig)
      	  mstore(add(4, mload(0x40)),_to)
		  mstore(add(36,mload(0x40)),_amout)
	      r := delegatecall(sub(gas, 700), tokenAddress, mload(0x40), 68, mload(0x40), 1)
	    }

	    if(r != 1){
	    	revert();
	    }

	    /*
		bool res = tokenAddress.delegatecall(bytes4(keccak256("transfer(address,uint256)")),_to, _amout);
		assert (res);
		*/
	}
}
