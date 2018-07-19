pragma solidity ^0.4.23;

/**
 * The StringLib library does this and that...
 */
library StringLib {
  
	function bytesEquals (bytes a, bytes b) public pure returns(bool res) {
		if( a.length != b.length){
			return false;
		}

		for(uint i=0; i < a.length; i++){
			if(a[i] != b[i]){
				return false;
			}
		}
		return true;
	}
}
