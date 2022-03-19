import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/products_provider.dart';

class ProductDetail extends StatelessWidget {
  static const routname = '/product_detail';

  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context)!.settings.arguments as String;

     final products = Provider.of<productProvider>(context).findById(id);

    return Scaffold(
      //appBar: AppBar(title: Text(products.title),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(products.title),
              background: Hero(
                  tag: products.id,
                  child: Image.network(products.imageUrl,fit: BoxFit.cover,)),
            ),
            ),
          SliverList(
              delegate: SliverChildListDelegate(
                [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text("\$${products.price}",style: TextStyle(color: Colors.grey,fontSize: 20),),
                        SizedBox(height: 10,),
                        Text("${products.description}",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 800,)
                      ],
                    ),
                  )
                ]
              )
          )
        ],
      )
    );
  }
}
