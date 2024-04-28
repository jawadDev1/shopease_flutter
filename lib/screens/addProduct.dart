import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/widget/RoundButton.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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

  void addNewProduct() async {
    setState(() {
      isLoading = true;
    });
    if (image == null) {
      Utils().showToastMessage("Upload a product Image", false);
      return;
    }

    if (formKey.currentState!.validate()) {
      try {
        // Uploading product image
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref("Products/product" + randomAlphaNumeric(4));
        firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
        await Future.value(uploadTask);
        var url = await ref.getDownloadURL();

        // Upload product
        var id = randomAlphaNumeric(10);
        Map<String, dynamic> productInfoMap = {
          "title": titleController.text,
          "description": descriptionController.text,
          "price": priceController.text,
          "category": categoryController.text,
          "stock": stockController.text,
          "sizes": sizesController.text,
          "colors": colorsController.text,
          "image": url,
          "id": id,
        };

        await DatabaseMethods().addNewProduct(productInfoMap, id).then(
            (value) =>
                Utils().showToastMessage("Product added successfully", true));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 3, 5, 71),
        iconTheme: IconThemeData(color: Colors.white, size: 26.0),
      ),
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
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: "Enter title",
                                prefixIcon: Icon(Icons.text_fields_rounded)),
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
                            controller: descriptionController,
                            decoration: InputDecoration(
                                hintText: "Enter Description",
                                prefixIcon: Icon(Icons.description)),
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
                            controller: priceController,
                            decoration: InputDecoration(
                                hintText: "Enter Price",
                                prefixIcon: Icon(Icons.attach_money)),
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
                            controller: categoryController,
                            decoration: InputDecoration(
                                hintText: "Enter Category",
                                prefixIcon: Icon(Icons.category)),
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
                            keyboardType: TextInputType.number,
                            controller: stockController,
                            decoration: InputDecoration(
                                hintText: "Enter Stock",
                                prefixIcon: Icon(
                                    Icons.production_quantity_limits_rounded)),
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
                            controller: sizesController,
                            decoration: InputDecoration(
                              hintText: "Enter Sizes (comma separated)",
                              prefixIcon: Icon(Icons.format_size),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: colorsController,
                            decoration: InputDecoration(
                              hintText: "Enter Colors (comma separated)",
                              prefixIcon: Icon(Icons.color_lens),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                            height: 70,
                            child: IconButton(
                              onPressed: () async {
                                await getGalleryImage();
                              },
                              icon: image != null
                                  ? Image.file(image!.absolute)
                                  : Row(
                                      children: [
                                        Icon(Icons.image),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Text(
                                          "Upload image",
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 28,
                  ),
                  RoundButton(
                      title: "Add",
                      color: Colors.black,
                      isLoading: isLoading,
                      onTap: () {
                        addNewProduct();
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
