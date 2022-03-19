import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/order.dart' show Order;
import 'package:shoping_app/widgets/app_drawer.dart';
import 'package:shoping_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routname = '/orders';
  OrderScreen();

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("your order"),
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(
        child: CircularProgressIndicator(),
      ):
      ListView.builder(itemCount: ordersData.orders.length,
          itemBuilder: (ctx,index) => OrderItem(ordersData.orders[index])),
    );
  }
}

