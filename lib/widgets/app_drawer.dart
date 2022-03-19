import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/Auth.dart';
import 'package:shoping_app/screens/order_screen.dart';
import 'package:shoping_app/screens/user_product.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text("Hello Friends"),),
          Divider(),
          ListTile(leading: Icon(Icons.shop),title: Text("Shop"),onTap: ()
            {
               Navigator.pushReplacementNamed(context, '/');
            },),
          Divider(),
          ListTile(leading: Icon(Icons.payment),title: Text("Orders"),onTap: ()
          {
            Navigator.pushReplacementNamed(context, OrderScreen.routname);
          },),
          Divider(),
          ListTile(leading: Icon(Icons.edit),title: Text("Manage Products"),onTap: ()
          {
            Navigator.pushReplacementNamed(context, UserProducts.routName);
          },),
          Divider(),
          ListTile(leading: Icon(Icons.exit_to_app),title: Text("Logout"),onTap: ()
          {
            Navigator.pop(context);

            Provider.of<Auth>(context,listen: false).logout();
          },)
        ],
      ),
    );
  }
}
