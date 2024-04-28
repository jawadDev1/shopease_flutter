import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/screens/details.dart';
import 'package:shopeease/widget/filterWidget.dart';
import 'package:shopeease/widget/productCard.dart';
import 'package:shopeease/widget/widget_support.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textController = TextEditingController();

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

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
      bottomSheetColor: Colors.white,
      builder: (context, controller, offset) {
        return FilterWidget(
          scrollController: controller,
          bottomSheetOffset: offset,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context);
    return Scaffold(
        // backgroundColor: Color(0xFF111111),
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
                    style: AppWidget.boldTextStyle(),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(11.0)),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 26.0,
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
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter search term',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showFilters();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    margin: EdgeInsets.only(left: 11.0),
                    decoration: BoxDecoration(
                        color: Colors.green,
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
              style: AppWidget.headingTextStyle(),
            ),
            SizedBox(
              height: 20.0,
            ),
            showCategories(),
            SizedBox(
              height: 30,
            ),
            Container(
              height: ScreenSize.size.height * 0.5,
              child: StreamBuilder(
                stream: productsRef.snapshots(),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14.0,
                          crossAxisSpacing: 14.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          debugPrint(
                              "****************************************");
                          debugPrint(documents[index].data().toString());
                          if (documents[index].data() == null) {
                            return CircularProgressIndicator(); // Placeholder widget
                          }

                          Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;
                          return ProductCard(
                            productImage: data['image'],
                            title: data['title'],
                            price: data['price'],
                            description: data['description'],
                            stock: data['stock'],
                            sizes: data['sizes'],
                            colors: data['colors'],
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
  Widget showCategories() {
    var ScreenSize = MediaQuery.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => Details()));
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
                    child: Image(
                      image: AssetImage('images/gun.jpg'),
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: 12.0,
                  left: (ScreenSize.size.width * 0.20),
                  child: Text(
                    "Guns",
                    style: AppWidget.categoryTextStyle(),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: ScreenSize.size.height * 0.24,
                  child: Image(
                    image: AssetImage('images/shoes.jpg'),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 12.0,
                left: (ScreenSize.size.width * 0.30),
                child: Text(
                  "Shoes",
                  style: AppWidget.categoryTextStyle(),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: ScreenSize.size.height * 0.24,
                  child: Image(
                    image: AssetImage('images/jet.jpg'),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 12.0,
                left: (ScreenSize.size.width * 0.30),
                child: Text(
                  "Fighter Jet",
                  style: AppWidget.categoryTextStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}









// GridView.count(
//               shrinkWrap: true,
//               crossAxisCount: 2,
//               mainAxisSpacing: 14.0,
//               padding: EdgeInsets.symmetric(vertical: 11.0),
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Details(
//                                   title: "Nike Shoes",
//                                   image: 'shoes.jpg',
//                                 )));
//                   },
//                   child: ProductCard(
//                     ProductImage: "shoes.jpg",
//                     Title: "Nike Shoes",
//                     Price: "130",
//                   ),
//                 ),
//                 ProductCard(
//                   ProductImage: "gun.jpg",
//                   Title: "M4A1 Gun",
//                   Price: "250",
//                 ),
//                 ProductCard(
//                   ProductImage: "jet.jpg",
//                   Title: "Fighter Jet",
//                   Price: "50M",
//                 ),
//               ],
//             ),