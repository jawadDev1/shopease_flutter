import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/RoundButton.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key, this.product});

  final Map<String, dynamic>? product;

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  // Text Controllers
  final titleController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final priceController = new TextEditingController();
  final categoryController = new TextEditingController();
  final stockController = new TextEditingController();
  final sizesController = new TextEditingController();
  final colorsController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  File? image;
  final picker = ImagePicker();
  var url;

  Future getGalleryImage() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      } else {
        Utils().showToastMessage("Pick an image", false);
      }
    });
  }

  void updateProduct() async {
    setState(() {
      isLoading = true;
    });
    if (image != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref("Products/product" + randomAlphaNumeric(4));
      firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
      await Future.value(uploadTask);
      url = await ref.getDownloadURL();
    } else {
      url = widget.product!['image'];
    }

    if (formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> productInfoMap = {
          "title": titleController.text,
          "description": descriptionController.text,
          "price": priceController.text,
          "category": categoryController.text,
          "stock": stockController.text,
          "sizes": sizesController.text,
          "colors": colorsController.text,
          "image": url,
          "id": widget.product!['id'],
        };

        await DatabaseMethods()
            .updateProduct(productInfoMap, widget.product!['id'])
            .then((value) =>
                Utils().showToastMessage("Product updated successfully", true));
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        Utils().showToastMessage(e.toString(), false);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: Colors.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: titleController
                              ..text = widget.product!['title'],
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter title",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: AppTheme.white,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter title";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: descriptionController
                              ..text = widget.product!['description'],
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Description",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(Icons.description,
                                    color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter Description";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: priceController
                              ..text = widget.product!['price'].toString(),
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Price",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(Icons.attach_money,
                                    color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter price";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: categoryController
                              ..text = widget.product!['category'],
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Category",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(Icons.category,
                                    color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter category";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: stockController
                              ..text = widget.product!['stock'].toString(),
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Stock",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(
                                    Icons.production_quantity_limits_rounded,
                                    color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter stock";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: sizesController
                              ..text = widget.product!['sizes'],
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                              hintText: "Enter Sizes (comma separated)",
                              hintStyle: TextStyle(color: AppTheme.white),
                              prefixIcon: Icon(Icons.format_size,
                                  color: AppTheme.white),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter sizes";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: colorsController
                              ..text = widget.product!['colors'],
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                              hintText: "Enter Colors (comma separated)",
                              hintStyle: TextStyle(color: AppTheme.white),
                              prefixIcon:
                                  Icon(Icons.color_lens, color: AppTheme.white),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter colors";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                            height: 100,
                            child: IconButton(
                                onPressed: () async {
                                  await getGalleryImage();
                                },
                                icon: image != null
                                    ? Image.file(image!.absolute)
                                    : Image(
                                        image: NetworkImage(
                                            widget.product!['image']))),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 28,
                  ),
                  RoundButton(
                      title: "update",
                      color: AppTheme.primary,
                      isLoading: isLoading,
                      onTap: () {
                        updateProduct();
                      }),
                  SizedBox(
                    height: 28,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
