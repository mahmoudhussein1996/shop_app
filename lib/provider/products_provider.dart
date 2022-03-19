import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoping_app/models/http_exception.dart';
import 'product.dart';

import 'package:http/http.dart' as http;

class productProvider extends ChangeNotifier
{
  List<product> _items = [
  ];

  final String _token;
  final String userId;

  productProvider(this._token,this.userId,this._items);
  var _showOnlyFavorites = false;

  List<product> get items
  {
    if(_showOnlyFavorites)
      {
        return _items.where((prodItem) => prodItem.isFavorite).toList();
      }
     else
       return [..._items];
  }

  Future<void> fetchAndSetProducts(bool filterByUser) async {

    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopping-ce0af-default-rtdb.firebaseio.com/products.json?auth=$_token&$filterString';

    try {
      final response = await http.get(Uri.parse(url));

      final extractedData = json.decode(response.body.toString()) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      url =
      'https://shopping-ce0af-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$_token';
      final favoriteResponse = await http.get(Uri.parse(url));

      final List<product> loadedProducts = [];

          final favoriteData = json.decode(favoriteResponse.body.toString());

      var isFav;

          extractedData.forEach((prodId, prodData) {
            if(favoriteData == null || favoriteData[prodId] == null)
              {
                isFav = false;
              }
            else{
              isFav = true;
            }
            loadedProducts.add(product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              isFavorite: isFav,
              imageUrl: prodData['imageUrl'],
            ));
          });

      _items = loadedProducts;
      notifyListeners();

    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(product Product) async {
    try {
      final response = await http.post(
        Uri.parse("https://shopping-ce0af-default-rtdb.firebaseio.com/products.json?auth=$_token"),
        body: json.encode({
          'title': Product.title,
          'description': Product.description,
          'imageUrl': Product.imageUrl,
          'price': Product.price,
          'creatorId': userId,

        }),
      );
      final newProduct = product(
        title: Product.title,
        description: Product.description,
        price: Product.price,
        imageUrl: Product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, product newProduct)
  async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      //final url = 'https://flutter-update.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse("https://shopping-ce0af-default-rtdb.firebaseio.com/products/$id.json?auth=$_token"),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
   // final url = 'https://flutter-update.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse("https://shopping-ce0af-default-rtdb.firebaseio.com/products/$id.json?auth=$_token"));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }


  product findById(String id)
  {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void showFavorrites()
  {
    _showOnlyFavorites = true;
    notifyListeners();
  }

  void showAll()
  {
    _showOnlyFavorites = false;
    notifyListeners();
  }
}