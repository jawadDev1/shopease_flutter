import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/RoundButton.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final categoryController = new TextEditingController();

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

  void addNewCategory() async {
    setState(() {
      isLoading = true;
    });
    if (image == null) {
      Utils().showToastMessage("Upload a product Image", false);
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (formKey.currentState!.validate()) {
      try {
        // Uploading Category image
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref("Categories/category" + randomAlphaNumeric(4));
        firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);
        await Future.value(uploadTask);
        var url = await ref.getDownloadURL();

        // Upload Category
        var id = randomAlphaNumeric(10);
        Map<String, dynamic> categoryInfoMap = {
          "category": categoryController.text,
          "image": url,
          "id": id,
        };

        await DatabaseMethods().addNewCategory(categoryInfoMap, id).then(
            (value) =>
                Utils().showToastMessage("Category added successfully", true));
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
        title: Text("Add Category"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: Colors.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
                        controller: categoryController,
                        style: TextStyle(color: AppTheme.white),
                        decoration: InputDecoration(
                            hintText: "Enter Category",
                            hintStyle: TextStyle(color: AppTheme.white),
                            prefixIcon: Icon(
                              Icons.category,
                              color: AppTheme.white,
                            )),
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
                                    Icon(
                                      Icons.image,
                                      color: AppTheme.white,
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text(
                                      "Upload image",
                                      style: TextStyle(
                                          fontSize: 15, color: AppTheme.white),
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
                  color: AppTheme.primary,
                  isLoading: isLoading,
                  onTap: () {
                    addNewCategory();
                  }),
              SizedBox(
                height: 28,
              ),
            ]),
      ),
    );
  }
}
