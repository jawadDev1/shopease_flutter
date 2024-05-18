import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:shopeease/controllers/cart_controller.dart';
import 'package:shopeease/screens/checkout/checkout.dart';
import 'package:shopeease/utils/theme.dart';

import 'package:shopeease/widget/RoundButton.dart';

class OrderInfo extends StatefulWidget {
  const OrderInfo({super.key});

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  // Text Controllers
  final nameController = new TextEditingController();
  final countryController = new TextEditingController();
  final cityController = new TextEditingController();
  final addressController = new TextEditingController();
  final phoneController = new TextEditingController();
  final postalCodeController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  final CartController cartController = Get.put(CartController());

  void addOrderInfo() {
    if (formKey.currentState!.validate()) {
      cartController.orderInfo = {
        "name": nameController.text,
        "country": countryController.text,
        "city": cityController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "postal": postalCodeController.text,
        "products": cartController.cart,
        "totalPrice": cartController.totalPrice.toString(),
        "userId": user!.uid,
        "status": "PENDING",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: Colors.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nameController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter Name",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(
                                  Icons.text_fields_rounded,
                                  color: AppTheme.white,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: countryController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter country",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon:
                                    Icon(Icons.map, color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter country";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: cityController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter city",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon: Icon(Icons.location_city_outlined,
                                    color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter city";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: addressController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter address",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon:
                                    Icon(Icons.house, color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: phoneController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                                hintText: "Enter phone",
                                hintStyle: TextStyle(color: AppTheme.white),
                                prefixIcon:
                                    Icon(Icons.phone, color: AppTheme.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter phone";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: postalCodeController,
                            style: TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                              hintText: "Enter postal code",
                              hintStyle: TextStyle(color: AppTheme.white),
                              prefixIcon: Icon(Icons.markunread_mailbox,
                                  color: AppTheme.white),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter postal code";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 28,
                  ),
                  RoundButton(
                      title: "Proceed",
                      color: AppTheme.primary,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          addOrderInfo();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Checkout()));
                        }
                      }),
                  SizedBox(
                    height: 28,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
