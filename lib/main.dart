import 'package:flutter/material.dart';
import 'package:shoping_app/provider/Auth.dart';
import 'package:shoping_app/provider/cart.dart';
import 'package:shoping_app/provider/order.dart';
import 'package:shoping_app/provider/products_provider.dart';
import 'package:shoping_app/screens/auth_Screen.dart';
import 'package:shoping_app/screens/cart_Screen.dart';
import 'package:shoping_app/screens/edit_product.dart';
import 'package:shoping_app/screens/order_screen.dart';
import 'package:shoping_app/screens/product_detail.dart';
import 'package:shoping_app/screens/splash_screen.dart';
import 'package:shoping_app/screens/user_product.dart';
import 'screens/product_overview.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth,productProvider>(create: (context)=> productProvider("","",[]), update: (context,auth,prviousProduct) => productProvider(auth.token,auth.userId,prviousProduct == null ? [] : prviousProduct.items)),
        ChangeNotifierProvider(create: (context) => Cart(),),
        ChangeNotifierProxyProvider<Auth,Order>(create: (context)=> Order("","",[]), update: (context,auth,prviousOrder) => Order(auth.token,auth.userId,prviousOrder == null ? [] : prviousOrder.orders)),

      ],
      child: Consumer<Auth>(builder: (context,auth,child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          //fontFamily: 'Lato'
        ),
        routes: {
          ProductDetail.routname: (context) => ProductDetail(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routname: (context) => OrderScreen(),
          UserProducts.routName: (context) => UserProducts(),
          EditProduct.routName: (context) => EditProduct()
        },
        home: auth.isAuth ? ProductOverview() :
        FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (context,autoresult) => autoresult.connectionState == ConnectionState.waiting ? SplashScreen():AuthScreen())
      ),),);
  }
}
