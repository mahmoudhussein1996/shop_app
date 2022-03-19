import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/products_provider.dart';
import 'package:shoping_app/screens/edit_product.dart';
import 'package:shoping_app/widgets/app_drawer.dart';
import 'package:shoping_app/widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  static const routName = '/UserProducts';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<productProvider>(context,listen: false).fetchAndSetProducts(true);
  }

  UserProducts();

  @override
  Widget build(BuildContext context) {
    //var produdata = Provider.of<productProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Products"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProduct.routName);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Consumer<productProvider>
                            (
                            builder: (context,prductdata,_) => ListView.builder(
                                itemCount: prductdata.items.length,
                                itemBuilder: (context, index) => UserProductItem(
                                    prductdata.items[index].id,
                                    prductdata.items[index].title,
                                    prductdata.items[index].imageUrl)),
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
