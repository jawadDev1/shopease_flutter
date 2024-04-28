import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserRecord(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // Get user info
  Future getUserInfo(String uid) async {
    var querySanpShot = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .get();
    if (querySanpShot.docs.isNotEmpty) {
      return querySanpShot.docs.first.data();
    }
  }

  // Add Product
  Future addNewProduct(Map<String, dynamic> productInfoMap, id) async {
    return FirebaseFirestore.instance
        .collection("products")
        .doc(id)
        .set(productInfoMap);
  }
}
