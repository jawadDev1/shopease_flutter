import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shopeease/controllers/cart_controller.dart';

import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/reviewCard.dart';
import 'package:shopeease/widget/stars.dart';

class ExpandedWidget extends StatefulWidget {
  ExpandedWidget({
    super.key,
    required this.ProductCount,
    required this.size,
    required this.stock,
    required this.title,
    required this.description,
    required this.productSizes,
    required this.color,
    required this.productColors,
    required this.image,
    required this.price,
    required this.productId,
  });

  final int? ProductCount;
  final String? size;
  final String? color;
  final String? title;
  final String? description;
  final int stock;
  final String? productSizes;
  final String? productColors;
  final String? image;
  final int? price;
  final String? productId;

  @override
  State<ExpandedWidget> createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget> {
  num? productCount;
  String? size;
  String? title;
  String? description;
  String? color;
  String? image;
  int? price;
  int? stock;
  List? productSizes;
  List? productColors;
  String? productId;

  var user = FirebaseAuth.instance.currentUser;
  final CartController cartController = Get.put(CartController());

  bool isLoading = false;

  void addToCart(Map<String, dynamic> product) async {
    bool productExists =
        cartController.cart.any((item) => item["productId"] == productId);

    if (productExists) {
      Utils().showToastMessage("product is already in cart", false);
      return;
    }

    cartController.cart.add(product);
    Utils().showToastMessage("product added to cart successfully", true);
    var productPrice = price! * productCount!.toInt();
    cartController.totalPrice += productPrice;
  }

  @override
  void initState() {
    productCount = widget.ProductCount;
    size = widget.size;
    title = widget.title;
    description = widget.description;
    stock = widget.stock;
    color = widget.color;
    image = widget.image;
    price = widget.price;
    productId = widget.productId;

    productSizes = widget.productSizes!.split(',');
    productColors = widget.productColors!.split(',');
    super.initState();
  }

  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context);
    TextEditingController commentTextController = TextEditingController();
    return Container(
      width: ScreenSize.size.width * 0.90,
      padding: EdgeInsets.symmetric(vertical: 21.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: Color.fromARGB(70, 0, 85, 255),
          borderRadius: BorderRadius.circular(11.0)),
      child: Column(
        children: [
          Center(
            child: Icon(
              Icons.arrow_drop_down,
              size: 28,
              color: Colors.white,
            ),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      ),
                      Text(
                        '\$$price',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat-Bold',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  // Review and Counter Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stars(4.5),
                          Text(
                            "(3.4k)",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),

                      // Counter
                      Container(
                        width: ScreenSize.size.width * .32,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(11.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (productCount! > 1) {
                                    productCount = productCount! - 1;
                                  }
                                });
                              },
                              child: Container(
                                  // width: ScreenSize.size.width * .08,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 13),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.white),
                                  )),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              "$productCount",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (productCount! < stock!) {
                                    productCount = productCount! + 1;
                                  }
                                });
                              },
                              child: Container(
                                  // width: ScreenSize.size.width * .08,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 13),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.white),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 31,
                  ),
                  // Description
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Montserrat-Bold",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$description",
                    maxLines: 7,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Roboto-Regular",
                        color: Colors.white),
                  ),

                  SizedBox(
                    height: 26,
                  ),

                  // Sizes
                  Text(
                    "Sizes",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: "Montserrat-Bold",
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: productSizes!.map((size) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              this.size = size;
                            });
                          },
                          child: Container(
                            width: ScreenSize.size.width * .2,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 9),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: this.size == size
                                      ? AppTheme.primary
                                      : Colors.white),
                              color: this.size == size
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat-Regular",
                                  fontWeight: FontWeight.w600,
                                  color: this.size == size
                                      ? Colors.white
                                      : Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),

                  // Colors
                  Text(
                    "Colors",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: "Montserrat-Bold",
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: productColors!.map((productColor) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              this.color = productColor;
                            });
                          },
                          child: Container(
                            // width: ScreenSize.size.width * .2,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 9),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: productColor == color
                                      ? AppTheme.primary
                                      : Colors.white),
                              color: productColor == color
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Text(
                              productColor,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat-Regular",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(
                    height: 26,
                  ),

                  // Reviews
                  Text(
                    "Reviews",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: "Montserrat-Bold",
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  ReviewCard(
                    Name: "Roronoa Zoro",
                    Rating: 3.5,
                    Comment:
                        "Nike shoes are renowned for their iconic designs, innovative technologies, and unwavering commitment",
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(ScreenSize.size.width * 0.8,
                              ScreenSize.size.height * 0.04),
                          backgroundColor: AppTheme.primary),
                      onPressed: () {},
                      child: Text(
                        "view all",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 11,
                  ),
                  // Add Comment
                  Text(
                    "Comment",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: "Montserrat-Bold",
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: commentTextController,
                    style: TextStyle(color: AppTheme.white),
                    decoration: InputDecoration(
                        hintText: "Enter comment",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 11,
          ),
          // Add To Cart Button
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: Size(
                    ScreenSize.size.width * 0.8, ScreenSize.size.height * .06),
              ),
              onPressed: () async {
                Map<String, dynamic> product = {
                  "title": title,
                  "price": price,
                  "quantity": productCount,
                  "userId": user!.uid,
                  "productId": productId,
                  "image": image,
                  "stock": stock
                };

                addToCart(product);
              },
              child: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    )
                  : Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))
        ],
      ),
    );
  }
}
