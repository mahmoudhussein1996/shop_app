import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/products_provider.dart';
import '../widgets/product_item.dart';
import '../provider/product.dart';

class ProductGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {



    final productData = Provider.of<productProvider>(context);
    final products =  productData.items;

    return  GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio:  2/ 4),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        )
    );
  }
}

