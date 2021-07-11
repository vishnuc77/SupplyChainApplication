 pragma solidity ^0.8.4;
 
 import "./Item.sol";
 import "./Ownable.sol";
 
 contract ItemManager is Ownable {
     
     enum SupplyChainState{Created, Paid, Delivered}
     
     struct S_Item {
         string _identifier;
         Item _item;
         ItemManager.SupplyChainState _step;
         
     }
     
     mapping(uint => S_Item) public items;
     uint index;
     
     event SupplyChainStep(uint _itemIndex, uint _step, address _address);
     
     function createItem(string memory _identifier, uint _priceInWei) public onlyOwner{
         Item item = new Item(this, index, _priceInWei);
         items[index]._item = item;
         items[index]._identifier = _identifier;
         items[index]._step = SupplyChainState.Created;
         emit SupplyChainStep(index, uint(items[index]._step), address(item));
         index++;
     }
     
     function triggerPayment(uint _index) public payable {
         Item item = items[_index]._item;
         require(address(item) == msg.sender, "Items can only be updated by themselves");
         require(item.priceInWei() == msg.value, "Not fully paid");
         require(items[_index]._step == SupplyChainState.Created, "Item is further in the supply chain");
         items[_index]._step = SupplyChainState.Paid;
         emit SupplyChainStep(_index, uint(items[_index]._step), address(item));
     }
     
     function triggerDelivery(uint _index) public onlyOwner{
         require(items[_index]._step == SupplyChainState.Paid, "Item is further in the supply chain");
         items[_index]._step = SupplyChainState.Delivered;
         emit SupplyChainStep(_index, uint(items[_index]._step), address(items[_index]._item));
     }
 }