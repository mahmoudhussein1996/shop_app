import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productid;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id,this.productid, this.price, this.quantity, this.title);


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(debugLabel: id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 15),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction)
      {
        Provider.of<Cart>(context,listen: false).deleteItem(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("\$${(price)}"),
              ),
            ),
            title: Text(title),
            subtitle: Text("\$${(price * quantity)}"),
            trailing: Text("$quantity X"),
          ),
        ),
      ),
    );
  }
}
