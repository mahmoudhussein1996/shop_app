import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shoping_app/provider/product.dart';
import 'package:shoping_app/provider/products_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProduct extends StatefulWidget {
  EditProduct();

  static const routName = '/editScreen';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = product(
    id: "",
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;


  var image;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(this.context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<productProvider>(this.context, listen: false)
            .findById(productId.toString());

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future PickImage(ImageSource source) async {
    final images = await ImagePicker().getImage(source: source);
    if (images == null) return;

    final temporaryimage = File(images.path);
    setState(() {
      image = temporaryimage;
    });
  }

  Future<String> uploadimage(File file) async {
    if (file == null) return "";

    String fileName = basename(file.path);
    final ref = FirebaseStorage.instance.ref("images/$fileName");

    UploadTask task = ref.putFile(file);

    final snapshot = await task.whenComplete(() {});

    String imageurl = await snapshot.ref.getDownloadURL();

    return imageurl;
  }

  void _saveForm() async{
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    var imageurl = await uploadimage(image);

    _editedProduct = product(
        title: _editedProduct.title,
        price: _editedProduct.price,
        description: _editedProduct.description,
        imageUrl: imageurl,
        id: _editedProduct.id,
        isFavorite: _editedProduct.isFavorite);

    if (_editedProduct.id == "") {

      try {
        await Provider.of<productProvider>(this.context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: this.context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              MaterialButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }

    }
    else {
      await Provider.of<productProvider>(this.context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(this.context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'please enter title';
                },
                onSaved: (value) {
                  _editedProduct = product(
                      title: value.toString(),
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: "",
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'price',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'please enter a price';
                  if (double.tryParse(value) == null)
                    return 'please enter a valid number';
                  if (double.tryParse(value)! <= 0)
                    return 'Please enter a number greater than zero';

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = product(
                      title: _editedProduct.title,
                      price: double.parse(value.toString()),
                      description: _editedProduct.description,
                      imageUrl: "",
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'description',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'please enter a description';
                  if (value.length < 10)
                    return 'description should be at least 10 character';
                },
                onSaved: (value) {
                  _editedProduct = product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value.toString(),
                      imageUrl: "",
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                textInputAction: TextInputAction.next,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: image != null
                        ? Image.file(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            'lib/assets/addimage.png',
                            width: 100,
                            height: 100,
                          ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text("camera"),
                                      onTap: () {
                                        PickImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      }),
                                  ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text("gallery"),
                                      onTap: () {
                                        PickImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      })
                                ],
                              ));
                    },
                  ),
                  image != null
                      ? Text("تم اختيار الصورة ")
                      : Text("رجاء لختيار صورة للمنتج")
                ],
              ),

              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                    child: Text("save",style: TextStyle(fontSize: 20),),
                    onPressed: (){

                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
