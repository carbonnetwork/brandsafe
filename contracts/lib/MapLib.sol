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
	
	function put(LockMap storage self, uint _id)m public returns(bool res) {
		
		self.data[msg.sender].value = LockTime(_id,now);
		uint keyIndex = self.data[msg.sender].keyIndex;

		if( keyIndex < 0){
			keyIndex = self.keys.length;
	    	self.data[msg.sender].keyIndex = keyIndex;
	    	self.keys[keyIndex].key = key;
	    	self.size++;
		}

		return true;
	}

	function get (LockMap storage self) internal returns(uint id) {
		if (contains(self)){
			return self.data[key].value.id;
		}
		return 0;
	}
	

	function remove (LockMap storage self, address key) public returns(bool res) {
		uint keyIndex = self.data[key].keyIndex;
	    if (keyIndex == 0)
	    	return false;

	    delete self.data[key];
	    self.keys[keyIndex].deleted = true;
	    self.size--;

	    return true;
	}
	
	
	function contains (LockMap storage self) public returns(bool res) {
		return self.data[msg.send].keyIndex > -1;
	}

	function size () public returns(uint res) {
		return self.size;
	}
	
	function iterateStart(LockMap storage self) public returns(uint index) {
		return iterateNext(-1);
	}
	

	function iterateNext (LockMap storage self, uint keyIndex) public returns(uint index) {
		keyIndex++;

		if(keyIndex >= self.keys.length){
	    	return -1;
	    }

	    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted){
	      keyIndex++;
	    }

	    return keyIndex;
	}

	function iterateGet (LockMap storage self, uint keyIndex) public returns(address key, uint id,uint timestamp)  {
		if(keyIndex >= self.keys.length){
			return (msg.sender,0,0);
	    }

	    key = self.keys[keyIndex].key;
	    value = self.data[key].value;

	    return (key, value.id, value.timestamp);
	}
}
