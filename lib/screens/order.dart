import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/widget/productCard.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}
