import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shopeease/screens/cart.dart';
import 'package:shopeease/screens/categoryProducts.dart';

import 'package:shopeease/screens/listProducts.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/filterWidget.dart';
import 'package:shopeease/widget/productCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  // Categoreis
  List<Map<String, dynamic>> categories = [];

  Future<void> getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      setState(() {
        categories = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      Utils().showToastMessage(e.toString(), false);
    }
  }

  // Show filter view
  void showFilters() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 0.9,
      context: context,
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
      ),
      bottomSheetColor: AppTheme.white,
      builder: (context, controller, offset) {
        return FilterWidget(
          scrollController: controller,
          bottomSheetOffset: offset,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: AppTheme.background,
        body: Container(
          height: ScreenSize.size.height * 0.9,
          margin: EdgeInsets.only(
            top: 30.0,
            left: 12.0,
            right: 12.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "ShopEase",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-Bold',
                            color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(11.0)),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 26.0,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart()));
                          },
                        ),
                      )
                    ]),
                SizedBox(
                  height: 30.0,
                ),

                // Search
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignInside,
                              color: AppTheme.primary),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Expanded(
                            child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Enter search term',
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "enter a search term";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListProducts(
                                                searchTerm:
                                                    searchController.text,
                                                isSearched: true,
                                              )));
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ))
                          ],
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showFilters();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        margin: EdgeInsets.only(left: 11.0),
                        decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Categories",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat-Bold',
                      color: AppTheme.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                showCategories(categories),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Products",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat-Bold',
                      color: AppTheme.white),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: ScreenSize.size.height * 0.65,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Text('No data available');
                      } else {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;

                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 28.0,
                              crossAxisSpacing: 14.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              if (documents[index].data() == null) {
                                return CircularProgressIndicator(); // Placeholder widget
                              }

                              Map<String, dynamic> data = documents[index]
                                  .data() as Map<String, dynamic>;
                              return ProductCard(
                                productImage: data['image'],
                                title: data['title'],
                                price: int.parse(data['price']),
                                description: data['description'],
                                stock: data['stock'],
                                sizes: data['sizes'],
                                colors: data['colors'],
                                productId: data['id'],
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // Categories Component
  Widget showCategories(List<Map<String, dynamic>> categoryMap) {
    var ScreenSize = MediaQuery.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoryMap.map((category) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryProducts(
                            category: category['category'],
                          )));
            },
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: ScreenSize.size.height * 0.24,
                  width: ScreenSize.size.width * 0.50,
                  child: Image(
                    image: NetworkImage(category[
                        'image']), // Assuming 'image' is a field in your Firestore documents
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 12.0,
                  left: (ScreenSize.size.width * 0.14),
                  child: Center(
                    child: Text(
                      category[
                          'category'], // Assuming 'name' is a field in your Firestore documents
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
