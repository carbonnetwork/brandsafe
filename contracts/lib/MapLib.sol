pragma solidity ^0.4.23;

/**
 * The MapLib library does this and that...
 */
library MapLib {
  
	struct LockMap {
		mapping (address => IndexValue) data;		
		keyFlag[] keys;
		uint size;
	}
	
	struct IndexValue {
		uint keyIndex;
		LockTime value;
	}
	
	struct keyFlag {
		address analysor;
		bool deleted;
	}	

	struct LockTime {
		uint id;
		uint timestamp;
	}
	
	function put(LockMap storage self, address _key, uint _id) public returns(bool res) {

		require (_key != address(0));
		
		self.data[_key].value = LockTime(_id,now);
		uint keyIndex = self.data[_key].keyIndex;

		if( keyIndex == 0){
			keyIndex = self.keys.length ++;
	    	self.data[_key].keyIndex = keyIndex + 1;
	    	self.keys[keyIndex].analysor = _key;
	    	self.size++;
		}

		return true;
	}

	function get (LockMap storage self, address _key) internal view returns(uint id) {
		if (contains(self, _key)){
			return self.data[_key].value.id;
		}
		return 0;
	}
	

	function remove (LockMap storage self, address _key) public returns(bool res) {
		uint keyIndex = self.data[_key].keyIndex;
	    if (keyIndex == 0)
	    	return false;

	    delete self.data[_key];
	    self.keys[keyIndex - 1].deleted = true;
	    self.size--;

	    return true;
	}
	
	
	function contains (LockMap storage self, address _key) public view returns(bool res) {
		return self.data[_key].keyIndex > 0;
	}

	function size (LockMap storage self) public view returns(uint res) {
		return self.size;
	}
	
	function iterateStart(LockMap storage self) public view returns(uint index) {
		return iterateNext(self, uint(-1));
	}
	
	function iterateValid(LockMap storage self, uint keyIndex) public view returns (bool){
    	return keyIndex < self.keys.length;
  	}

	function iterateNext (LockMap storage self, uint keyIndex) public view returns(uint index) {
		keyIndex++;

	    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted){
	      keyIndex++;
	    }

	    return keyIndex;
	}

	function iterateGet (LockMap storage self, uint keyIndex) public view returns(address key, uint id, uint timestamp)  {
		if(keyIndex >= self.keys.length){
			return (address(0),0,0);
	    }

	    key = self.keys[keyIndex].analysor;
	    LockTime storage value = self.data[key].value;

	    return (key, value.id, value.timestamp);
	}
}
