import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/screens/bottomnav.dart';
import 'package:shopeease/screens/auth/signup.dart';
import 'package:shopeease/testCode.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/widget/RoundButton.dart';
// import 'package:bmi_app/services/database.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await auth
          .signInWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordController.text.toString())
          .then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNav()))
              });
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      Utils().showToastMessage(e.toString(), false);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  // release from the memory
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 3, 5, 71),
      ),
      body: Padding(
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
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Enter Email",
                            prefixIcon: Icon(Icons.email)),
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
                        decoration: InputDecoration(
                            hintText: "Enter Password",
                            prefixIcon: Icon(Icons.lock_outline_rounded)),
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
                      SizedBox(
                        height: 28,
                      ),
                      RoundButton(
                          title: "Login",
                          color: Colors.black,
                          isLoading: isLoading,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              login();
                            }
                          }),
                      SizedBox(
                        height: 26,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        child: Text(
                          "doesn't have an account? Signup",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )),
            ]),
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