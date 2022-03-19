import 'package:flutter/cupertino.dart';

class CartItem
{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id,required this.title,required this.price,required this.quantity});

}


class Cart extends ChangeNotifier
{
  Map<String,CartItem> _items = {};

  Map<String,CartItem> get items
  {
    return {..._items};
  }

  int get itemCount
  {
    return _items.length;
  }

  double get itemAllAmount
  {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total+= cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(final String productId ,String title , double price)
  {
    if(_items.containsKey(productId))
      {
        _items.update(productId, (existringItem) => CartItem(
            id: existringItem.id,
            title: existringItem.title,
            price: existringItem.price,
            quantity: existringItem.quantity +1));
      }
    else{
      _items.putIfAbsent(productId, ()=> CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1));
    }
    notifyListeners();
  }
  void deleteItem(String productid)
  {
     _items.remove(productid);
     notifyListeners();
  }

  void RemoveItem(String productid)
  {
    if(!_items.containsKey(productid))
      return;

        if(_items[productid]!.quantity >1)
          {
            _items.update(productid, (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: existingItem.quantity-1));
          }
        else
          {
            _items.remove(productid);
          }

        notifyListeners();
  }
  void clear()
  {
    _items = {};
    notifyListeners();
  }
}