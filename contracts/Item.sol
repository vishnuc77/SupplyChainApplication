 pragma solidity ^0.8.4;
 
 import "./ItemManager.sol";
 
 contract Item {
     uint public index;
     uint public priceInWei;
     uint public paidWei;
     
     ItemManager parentContract;
     
     constructor (ItemManager _parentContract, uint _index, uint _priceInWei) {
         parentContract = _parentContract;
         index = _index;
         priceInWei = _priceInWei;
     }
     
     receive() external payable {
         require(paidWei == 0, "Item is already paid");
         require(priceInWei == msg.value, "Only full payments supported");
         paidWei += msg.value;
         (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
         require(success, "Payment was not successful");
     }
     
     fallback() external {
         
     }
 }