import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/screens/admin/dashboard.dart';
import 'package:shopeease/screens/auth/login.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  var user;
  String name = "";
  String email = "";
  String avatar = "";

  void getInfo() async {
    user =
        await DatabaseMethods().getUserInfo(auth.currentUser!.uid.toString());
    setState(() {
      name = user["Name"];
      email = user["Email"];
      avatar = user["Avatar"];
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: TextStyle(color: AppTheme.white),
        ),
        backgroundColor: AppTheme.primary,
        actions: [
          IconButton(
              onPressed: () {
                try {
                  auth.signOut().then((value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login())));
                } catch (e) {
                  Utils().showToastMessage(e.toString(), false);
                }
              },
              icon: Icon(
                Icons.logout_rounded,
                color: AppTheme.white,
              )),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Column(children: [
        SizedBox(
          height: 30,
        ),
        CircleAvatar(
          radius: 70.0,
          backgroundImage: NetworkImage(avatar),
        ),
        SizedBox(
          height: 30,
        ),
        ProfileCard(
          value: name,
          title: "Name",
          icon: Icon(
            Icons.person,
            color: AppTheme.white,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ProfileCard(
          value: email,
          title: "Email",
          icon: Icon(
            Icons.email,
            color: AppTheme.white,
          ),
        ),
      ]),
      floatingActionButton: user['isAdmin']
          ? FloatingActionButton(
              backgroundColor: AppTheme.primary,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Icon(
                Icons.add,
                color: AppTheme.white,
              ),
            )
          : Text(""),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key,
      required this.value,
      required this.title,
      required this.icon});

  final String value;
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
              color: AppTheme.card, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
