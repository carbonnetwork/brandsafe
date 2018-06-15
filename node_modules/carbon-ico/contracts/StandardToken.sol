pragma solidity ^0.4.23;

/**
 * The StandardToken  contract does this and that...
 */

import "./ERC20.sol";

import "./SafeMathLib.sol";

contract StandardToken is ERC20 {

	using SafeMathLib for uint256;

	mapping(address => uint) balances;

	mapping (address => mapping (address => uint)) allowed;

	/*
	 *fix short address bug
	 */
	modifier checkAddressSize(uint size) {	    
	    require (msg.data.length < size + 4);      
	    _;
	}

	/*
	function totalSupply() public constant returns (uint256 total){
		return 0;
	}*/


	function balanceOf(address _owner) public constant returns (uint256 balance) {
	    return balances[_owner];
	}


	function transfer(address _to, uint256 _value) public checkAddressSize(2 * 32) returns (bool success){
	    balances[msg.sender] = balances[msg.sender].sub(_value);
	    balances[_to] = balances[_to].add(_value);

	    emit Transfer(msg.sender, _to, _value);
	    return true;
	}


	function transferFrom(address _from, address _to, uint256 _value) public checkAddressSize(3 * 32) returns (bool success) {
	    uint _allowance = allowed[_from][msg.sender];

	    balances[_to] = balances[_to].add(_value);
	    balances[_from] = balances[_from].sub(_value);
	    allowed[_from][msg.sender] = _allowance.sub(_value);

	    emit Transfer(_from, _to, _value);
	    return true;
	}


	function approve(address _spender, uint256 _value) public returns (bool success) {
	    require ((_value != 0) && (allowed[msg.sender][_spender] != 0));

	    allowed[msg.sender][_spender] = _value;

	    emit Approval(msg.sender, _spender, _value);
	    return true;
	}


	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
	    return allowed[_owner][_spender];
	}
}
