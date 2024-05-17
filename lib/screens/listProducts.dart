import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/productCard.dart';

class ListProducts extends StatefulWidget {
  const ListProducts(
      {super.key,
      this.searchTerm,
      this.minPrice,
      this.maxPrice,
      required this.isSearched});
  final String? searchTerm;
  final String? minPrice;
  final String? maxPrice;
  final bool? isSearched;
  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  Stream? snapShots;

  Stream<dynamic> getProducts() async* {
    if (widget.isSearched!) {
      yield* await DatabaseMethods().getProductsBySearch(widget.searchTerm!);
    } else {
      yield* await DatabaseMethods()
          .getProductsByPrice(widget.minPrice!, widget.maxPrice!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          iconTheme: IconThemeData(color: AppTheme.white, size: 26.0),
        ),
        backgroundColor: AppTheme.background,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: StreamBuilder(
            stream: getProducts(),
            builder: (context, snapshot) {
              var products = snapshot.data!.docs;

              if (products.isEmpty) {
                return Center(child: Text("No products Found"));
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14.0,
                  crossAxisSpacing: 14.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index].data();

                  return ProductCard(
                      productImage: product['image'],
                      title: product['title'],
                      price: int.parse(product['price']),
                      description: product['description'],
                      stock: product['stock'],
                      sizes: product['sizes'],
                      colors: product['colors']);
                },
              );
            },
          ),
        ));
  }
}
