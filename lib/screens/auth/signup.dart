import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/screens/bottomnav.dart';
import 'package:shopeease/screens/auth/login.dart';

import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/RoundButton.dart';
// import 'package:bmi_app/services/database.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // For firebase Authentication
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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

  void signup() async {
    if (image == null) {
      Utils().showToastMessage("Upload an Avatar Image", false);
      return;
    }
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState!.validate()) {
      try {
        // Upload image in storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('Avatars/avatar' + randomString(4));
        firebase_storage.UploadTask uploadTask = ref.putFile(image!.absolute);

        await Future.value(uploadTask);
        var url = await ref.getDownloadURL();

        UserCredential user = await auth.createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString());

        setState(() {
          isLoading = false;
        });

        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Password": passwordController.text,
          "Avatar": url,
          "id": user.user!.uid.toString(),
          "isAdmin": false,
        };

        await DatabaseMethods()
            .addUserRecord(userInfoMap, user.user!.uid.toString())
            .then((value) => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNav())));
      } catch (e) {
        Utils().showToastMessage(e.toString(), false);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  // release from the memory
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
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
                            controller: nameController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter name",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon:
                                    Icon(Icons.person, color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Email",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: AppTheme.white,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter email";
                              } else if (!emailRegex.hasMatch(value)) {
                                return "enter a valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Password",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(Icons.lock_outline_rounded,
                                    color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 28,
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
                                        Icon(Icons.image,
                                            color: AppTheme.white),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Text(
                                          "Upload image",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: AppTheme.white),
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
                      title: "Signup",
                      color: AppTheme.primary,
                      isLoading: isLoading,
                      onTap: () {
                        signup();
                      }),
                  SizedBox(
                    height: 28,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

// ElevatedButton(
//             onPressed: () async {
//               String id = randomAlphaNumeric(12);
//               Map<String, dynamic> personInfoMap = {
//                 "Name": nameController.text,
//                 "Age": passwordController.text,
//                 "Degree": emailController.text,
//                 "id": id
//               };

//               await DatabaseMethods()
//                   .addPersonRecord(personInfoMap, id)
//                   .then((value) => Fluttertoast.showToast(msg: "Data Added"));
//             },
//             child: Text("Add Data"))