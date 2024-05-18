import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shopeease/controllers/cart_controller.dart';

import 'package:shopeease/screens/checkout/orderInfo.dart';
import 'package:shopeease/utils/theme.dart';

import 'package:shopeease/widget/RoundButton.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartController cartController = Get.put(CartController());
  List<Map<String, dynamic>>? cartProducts = [];
  final user = FirebaseAuth.instance.currentUser;
  int selectedItems = 0;
  num totalPrice = 0;

  void deleteItemFromCart(String productId, price, quantity) {
    cartController.cart
        .removeWhere((product) => product["productId"] == productId);
    var newPrice = int.parse(price) * quantity;
    cartController.totalPrice -= newPrice.toInt();
  }

  void increaseQuantity(String productId, int price) {
    cartController.increaseQuantity(productId, price);
  }

  void decreaseQuantity(String productId, int price) {
    cartController.decreaseQuantity(productId, price);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: Colors.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.cart.isEmpty) {
                return Center(
                  child: Text(
                    "cart is empty",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: cartController.cart.length,
                  itemBuilder: (context, index) {
                    var product = cartController.cart[index];
                    return CartCard(
                        title: product['title'],
                        image: product['image'],
                        quantity: product['quantity'],
                        price: product['price'].toString(),
                        productId: product['productId'],
                        stock: product['stock'],
                        userId: user!.uid,
                        deleteItemFromCart: deleteItemFromCart,
                        increaseQuantity: increaseQuantity,
                        decreaseQuantity: decreaseQuantity);
                  });
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    "Selected item (${cartController.cart.length})",
                    style: TextStyle(
                        fontSize: 19,
                        color: AppTheme.white,
                        fontFamily: "Roboto-Regular",
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Obx(() => Text(
                      "Total: \$${cartController.totalPrice}",
                      style: TextStyle(
                          fontSize: 19,
                          color: AppTheme.white,
                          fontFamily: "Roboto-Regular",
                          fontWeight: FontWeight.w500),
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RoundButton(
                title: "Proceed",
                color: AppTheme.primary,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderInfo()));
                }),
          )
        ],
      ),
    );
  }
}

class CartCard extends StatefulWidget {
  const CartCard({
    Key? key,
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.userId,
    required this.stock,
    required this.deleteItemFromCart,
    required this.increaseQuantity,
    required this.decreaseQuantity,
  }) : super(key: key);

  final String? image;
  final String title;
  final int quantity;
  final String price;
  final String productId;
  final String userId;
  final int? stock;
  final Function(String, String, int) deleteItemFromCart;
  final Function(String, int) increaseQuantity;
  final Function(String, int) decreaseQuantity;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int? _quantity;

  @override
  void initState() {
    _quantity = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
              color: AppTheme.card, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: screenSize.size.width * 0.20,
                    height: screenSize.size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Image(
                      image: NetworkImage(widget.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenSize.size.width * .21,
                        child: Text(
                          "${widget.title}",
                          style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 17.0,
                              fontFamily: "Montserrat-Regular",
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "\$${widget.price}",
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 32.0,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      widget.deleteItemFromCart(
                          widget.productId, widget.price, _quantity!);
                    },
                  ),
                  Container(
                    width: screenSize.size.width * .32,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                        // color: AppTheme.white,
                        borderRadius: BorderRadius.circular(11.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_quantity! > 1) {
                                _quantity = _quantity! - 1;
                                widget.decreaseQuantity(
                                    widget.productId, int.parse(widget.price));
                              }
                            });
                          },
                          child: Container(
                              // width: ScreenSize.size.width * .08,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 13),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "$_quantity",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_quantity! < widget.stock!) {
                                _quantity = _quantity! + 1;
                                widget.increaseQuantity(
                                    widget.productId, int.parse(widget.price));
                              }
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 13),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ],
                    ),
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
