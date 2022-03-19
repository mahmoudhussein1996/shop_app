import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/cart.dart';
import 'package:shoping_app/provider/products_provider.dart';
import 'package:shoping_app/screens/cart_Screen.dart';
import 'package:shoping_app/widgets/app_drawer.dart';
import 'package:shoping_app/widgets/badge.dart';
import 'package:shoping_app/widgets/product_grid.dart';

class ProductOverview extends StatefulWidget {
  const ProductOverview({Key? key}) : super(key: key);

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<productProvider>(context).fetchAndSetProducts(true).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var producType = Provider.of<productProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
              onSelected: (int selectedvalue) {
                if (selectedvalue == 0) {
                  producType.showFavorrites();
                } else {
                  producType.showAll();
                }

                //    print("data is $_showonlyFavorites");
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text("only favorites"),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text("show all"),
                  value: 1,
                )
              ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ): ProductGrid(),
    );
  }
}

