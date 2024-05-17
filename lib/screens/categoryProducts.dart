import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/productCard.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({super.key, required this.category});

  final String category;
  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  String? category;
  late Future<List<Map<String, dynamic>>> products;

  @override
  void initState() {
    super.initState();
    category = widget.category;

    products = fetchProductsByCategory();
  }

  Future<List<Map<String, dynamic>>> fetchProductsByCategory() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      Utils().showToastMessage(e.toString(), false);
      return [];
    }
  }

  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: AppTheme.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "$category",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-Bold',
                    color: AppTheme.white),
              ),
            ),
            SizedBox(
              height: 28,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No products found for category $category'),
                  );
                } else {
                  return Column(
                    children: [
                      Container(
                        height: ScreenSize.size.height * 0.7,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14.0,
                            crossAxisSpacing: 14.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              productImage: snapshot.data![index]['image'],
                              title: snapshot.data![index]['title'],
                              price: int.parse(snapshot.data![index]['price']),
                              description: snapshot.data![index]['description'],
                              stock: snapshot.data![index]['stock'],
                              sizes: snapshot.data![index]['sizes'],
                              colors: snapshot.data![index]['colors'],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
