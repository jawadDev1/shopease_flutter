import 'package:flutter/material.dart';
import 'package:shopeease/screens/details.dart';
import 'package:shopeease/widget/widget_support.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productImage,
    required this.title,
    required this.price,
    required this.description,
    required this.stock,
    required this.sizes,
    required this.colors,
  });

  final String productImage;
  final String title;
  final String price;
  final String description;
  final String stock;
  final String sizes;
  final String colors;

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Details(
                      title: title,
                      image: productImage,
                      descirption: description,
                      price: price,
                      colors: colors,
                      sizes: sizes,
                      stock: stock,
                    )));
      },
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            height: ScreenSize.size.height * 0.44,
            margin: EdgeInsets.only(left: 8.0, right: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Image(
              image: NetworkImage(productImage),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 1.0,
            left: 15.0,
            child: Container(
              width: ScreenSize.size.width * 0.39,
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppWidget.cardTextStyle(),
                  ),
                  Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                    size: 21.0,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 22.0,
            child: Container(
              width: ScreenSize.size.width * 0.3,
              padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 14.0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  borderRadius: BorderRadius.circular(11.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "\$$price",
                    style: AppWidget.cardTextStyle(),
                  ),
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.white,
                    size: 21.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
