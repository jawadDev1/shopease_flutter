import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopeease/screens/admin/addCategory.dart';
import 'package:shopeease/screens/admin/addProduct.dart';
import 'package:shopeease/screens/admin/allProducts.dart';
import 'package:shopeease/utils/theme.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: Colors.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCard(
            title: "All Products",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllProducts()));
            },
          ),
          SizedBox(
            height: 28,
          ),
          CustomCard(
            title: "Add Product",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProduct()));
            },
          ),
          SizedBox(
            height: 28,
          ),
          CustomCard(
            title: "Add Category",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCategory()));
            },
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.title, required this.onTap});

  final String title;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$title",
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 20.0,
                    fontFamily: "Montserrat-Bold",
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 37.0,
                  color: AppTheme.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
