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

  // Add Category
  Future addNewCategory(Map<String, dynamic> categoryInfoMap, id) async {
    return FirebaseFirestore.instance
        .collection("categories")
        .doc(id)
        .set(categoryInfoMap);
  }

  // Get Products by Category
  Future getCategoryProducts(String category) async {
    var querySanpShot = await FirebaseFirestore.instance
        .collection("products")
        .where("category", isEqualTo: category)
        .get();
    if (querySanpShot.docs.isNotEmpty) {
      return querySanpShot.docs.first.data();
    }
  }

  // Check if the product is in the cart or not
  Future<bool> isProductInCart(String productId, String userId) async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId)
        .get();

    return cartSnapshot.docs.isNotEmpty;
  }

  //  Get the cart products
  Future getSelectedItemsAndPrice(String userId) async {
    var querySanpshot = await FirebaseFirestore.instance
        .collection("cart")
        .where("userId", isEqualTo: userId)
        .get();

    if (querySanpshot.docs.isNotEmpty) {
      num totalPrice = 0;
      num selectedItems = 0;
      querySanpshot.docs.forEach((element) {
        totalPrice = totalPrice + int.parse(element['price']);
        selectedItems = selectedItems + 1;
      });
      return [selectedItems, totalPrice];
    }

    return null;
  }

// Delete Cart Item
  Future<bool> deleteCartItem(String productId, String userId) async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId)
        .get();

    await cartSnapshot.docs[0].reference.delete();
    return true;
  }

  // Add New Order
  Future addNewOrder(Map<String, dynamic> order, String id) async {
    print("******Order::::: $order");
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(id)
        .set(order);
  }

  // Get Products by Search
  Future getProductsBySearch(String searchTerm) async {
    return await FirebaseFirestore.instance
        .collection("products")
        .where("title", isEqualTo: searchTerm)
        .snapshots();
  }

  // Get Products by Price Range
  Future getProductsByPrice(String minPrice, String maxPrice) async {
    return await FirebaseFirestore.instance
        .collection("products")
        .where("price", isGreaterThan: int.parse(minPrice))
        .where("price", isLessThan: int.parse(maxPrice))
        .snapshots();
  }

  // Update Product
  Future updateProduct(Map<String, dynamic> product, String productId) async {
    return await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .update(product);
  }
}
