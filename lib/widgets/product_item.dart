import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/Auth.dart';
import 'package:shoping_app/provider/cart.dart';
import 'package:shoping_app/provider/product.dart';
import 'package:shoping_app/screens/product_detail.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productdata = Provider.of<product>(context,listen: false);
    final authdata = Provider.of<Auth>(context,listen: false);
    final cart = Provider.of<Cart>(context);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: ()
          {
            Navigator.pushNamed(context, ProductDetail.routname,arguments: productdata.id);
          },
          child: Column(
         children: [
           Hero(
             tag: productdata.id,
             child: FadeInImage(
               height: MediaQuery.of(context).size.height * 0.25,
               width: MediaQuery.of(context).size.width * 0.45,
               placeholder: AssetImage('lib/assets/product-placeholder.png'),
               image: NetworkImage(productdata.imageUrl),fit: BoxFit.cover,),
           ),
           SizedBox(
             height: 10,
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Consumer<product>(
                 builder: (context,productdata,child) => IconButton(icon: Icon(productdata.isFavorite ? Icons.favorite : Icons.favorite_border,color: Theme.of(context).accentColor),onPressed: (){
                   productdata.toggleFavoriteStatus(authdata.token,authdata.userId);
                 },),),

               Text(productdata.title,textAlign: TextAlign.center,),

               IconButton(icon: Icon(Icons.shopping_cart,color: Theme.of(context).primaryColor,)
                 ,onPressed: (){
                   cart.addItem(productdata.id, productdata.title, productdata.price);

                   var snackbar = SnackBar(
                     content: Text("item added to cart"),
                     action: SnackBarAction(label: 'Undo',onPressed: ()
                     {
                       cart.RemoveItem(productdata.id);
                     },),
                     duration: Duration(seconds: 2),);

                   ScaffoldMessenger.of(context).showSnackBar(snackbar);
                 },),
             ],
           )
         ],
        ),
      ),
    );
  }
}
