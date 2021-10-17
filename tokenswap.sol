import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

contract myTokenBob is ERC20 {
    
    constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
        
        //mint 100 tokens to msg.sender
        //similar to how 1 dollar = 100 cents
        //1 token = 1 * (10 ** decimals)
        
        // Mint 100 tokens with 18 decimals
        
        _mint(msg.sender, 100 * 10 ** uint(decimals()));
    }
    
    
    
    
}

//then create the token swap contract

//SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;


contract TokenSwap {
    //create state variables to store token and owner address
    
    IERC20 public token1;
    IERC20 public token2;
    address public owner1;
    address public owner2;
    
    //set initial owners of the tokens(owner 1 and owner 2)
    constructor(
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
        ) public {
            token1 = IERC20(_token1);
            owner1 = _owner1;
            
            token2 = IERC20(_token2);
            owner2 = _owner2;
        }
        
      //this function allows for tokens to swap(specific amounts)
      //Ensure there is an allowance function
      
      function swap(uint _amount1, uint _amount2) public {
          //ensure the msg.sender is an owner 
          //so not anyone can swap
          require(msg.sender == owner1 || msg.sender == owner2, "NOT AUTHORIZED");
          
          //ensure amount to be swapped is less than or equal to allowance
          //NB:- both token1 holder and token2 holder can be owner1
          //NB:- both token1 and token2 can be amount1
          require(token1.allowance(owner1, address(this)) >= _amount1, "ALLOWANCE TOO LOW");
          require(token2.allowance(owner1, address(this)) >= _amount1, "ALLOWANCE TOO LOW");
          
          //call the function _safeTransferFrom below
          _safeTransferFrom(token1, owner1, owner2, _amount1);
          _safeTransferFrom(token2, owner2, owner1, _amount2);
          
      }
        
        //a private function for tranfering the tokens that'll be called in the above function
        //also calls the transferFrom function for the IERC20 token, which automatically returns bool(sent)
        //NB:- the call must follow the exact order of arguements on the function below
        
        function _safeTransferFrom(IERC20 token, address sender, address recipient, uint amount) private {
         
         bool sent = token.transferFrom(sender, recipient, amount);
         require(sent, "Token transfer failed");
        }
    
}











