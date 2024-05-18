import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopeease/screens/admin/updateProduct.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  void deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .delete();
    } catch (e) {
      Utils().showToastMessage(e.toString(), false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Products"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
          centerTitle: true,
          backgroundColor: AppTheme.primary,
          iconTheme: IconThemeData(color: Colors.white, size: 26.0),
        ),
        backgroundColor: AppTheme.background,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("No products to display"));
            }

            return SingleChildScrollView(
              child: DataTable(
                  columnSpacing: 24.0,
                  dataRowHeight: 80.0,
                  columns: [
                    DataColumn(
                        label: Text(
                      "Image",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Montserrat-Bold",
                          color: AppTheme.white),
                    )),
                    DataColumn(
                        label: Text(
                      "Title",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Montserrat-Bold",
                          color: AppTheme.white),
                    )),
                    DataColumn(
                        label: Text(
                      "Price",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Montserrat-Bold",
                          color: AppTheme.white),
                    )),
                    DataColumn(
                        label: Text(
                      "Stock",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontFamily: "Montserrat-Bold",
                          color: AppTheme.white),
                    )),
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("")),
                  ],
                  rows: snapshot.data!.docs.map((e) {
                    var product = e.data();

                    return DataRow(cells: [
                      DataCell(
                        Container(
                          width: 45,
                          height: 80,
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.0)),
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(product['image']),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                            width: 55,
                            child: Text(
                              product['title'],
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontFamily: "Roboto-Regular"),
                            )),
                      ),
                      DataCell(Text(
                        "\$${product['price']}",
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 13,
                            fontFamily: "Roboto-Regular"),
                      )),
                      DataCell(
                        Text(
                          "${product['stock']}",
                          style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 12,
                              fontFamily: "Roboto-Regular"),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 8.0,
                          child: IconButton(
                            alignment: Alignment.centerLeft,
                            icon: Icon(
                              Icons.edit,
                              color: AppTheme.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateProduct(
                                            product: product,
                                          )));
                            },
                          ),
                        ),
                      ),
                      DataCell(IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteProduct(product['id']);
                        },
                      )),
                    ]);
                  }).toList()),
            );
          },
        ));
  }
}
