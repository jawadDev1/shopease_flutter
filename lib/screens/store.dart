import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/productCard.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 40.9,
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
            height: 14,
          ),
          Container(
            height: ScreenSize.size.height * 0.5,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
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
                        if (documents[index].data() == null) {
                          return CircularProgressIndicator(); // Placeholder widget
                        }

                        Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
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
        ]),
      ),
    );
  }
}
