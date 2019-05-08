pragma solidity ^0.5.0;

contract EYERC20 {
    function transfer(address _to, uint _value) public returns (bool success);
    
    function approve(address _spender, uint _value) public returns (bool success);
    
    function allowance(address _owner, address _spender) public returns(uint amount);
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);

//Events

event Transfer(address _from, address _to, uint256 _value);

event Approval(address _owner, address _spender, uint256 _value);

}

contract StandardToken is EYERC20 {
    mapping (address => mapping(address => uint)) allowed;
    
    uint256 public totalSupply;
    
    //Ledger that maintains balance of each user
    mapping(address => uint256) public balanceOf;
    
    function transfer(address _to, uint256 _value) public returns(bool success) {
        require(balanceOf[msg.sender] > _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
       emit Transfer(msg.sender, _to, _value); // Emit an event
        return true;
        
        
    } 
    
    function approve(address _spender, uint256 _value ) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //emit an event
        return true;
    }
    
    //Find out how much one can withdraww from address of owner;
    function allowance(address _owner, address _spender) public returns (uint amount) {
        return allowed[_owner][_spender];
    }
    
    // Function lets msg.sender transfer tokens from _from address to _to address
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success){
        if(balanceOf[_from] > _value && allowed[_from][msg.sender] > _value && _value >0) {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
            
        } else {
            return false;
        }
    }
}

contract EYCoin is StandardToken {
    string public name  = "EY coin";
    string public symbol = "EYC";
    uint8 public decimals = 18;
    uint public totalSupply = 1000000000000000000000;
    
    constructor() public payable {
        balanceOf[msg.sender] = totalSupply;
    }
    
}

contract EYCoinICO {
    uint256 public unitsOneEthCanBuy; // How many units of EYCoin can be bought with 1 ETH?
    uint256 public totalEthInWei; // we will store ETH raised through ICO here
    address payable fundsWallet; // Where does the raised ETH go?
    StandardToken public token;
    
    constructor(uint256 _unitsOneEthCanBuy) public payable {
        unitsOneEthCanBuy = _unitsOneEthCanBuy;
        fundsWallet = msg.sender;
        token = new EYCoin(); // Deploy the token contract and store in token property;
        
    }
    
    function() external payable {
        totalEthInWei += msg.value;
        uint256 amount = msg.value * unitsOneEthCanBuy;
        token.transfer(msg.sender, amount);
        
        //Transfer ETH to fundsWallet
      
       fundsWallet.transfer(amount);
        
    }
    

    
}