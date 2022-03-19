import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/cart.dart';
import 'package:shoping_app/provider/order.dart';
import 'package:shoping_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("your cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                "Total",
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Chip(
                label: Text(
                  "\$${cart.itemAllAmount}",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
              ),
              MaterialButton(
                child: Text(
                  "Order Now",
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor),
                ),
                onPressed: () {
                  Provider.of<Order>(context,listen: false).addOrder(
                      cart.items.values.toList(),
                      cart.itemAllAmount);

                  cart.clear();
                },
              ),
             ]
            ),
          )),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width:  MediaQuery.of(context).size.width ,
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) =>
                    ci.CartItem(
                        cart.items.values.toList()[index].id,
                        cart.items.keys.toList()[index],
                        cart.items.values.toList()[index].price,
                        cart.items.values.toList()[index].quantity,
                        cart.items.values.toList()[index].title
                    )
            ),

          )
        ]
      ),
    );
  }
}
