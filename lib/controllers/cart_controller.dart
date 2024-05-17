import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:random_string/random_string.dart';
import 'package:shopeease/database.dart';
import 'package:shopeease/utils/Utils.dart';

class CartController extends GetxController {
  RxList cart = [].obs;
  var totalPrice = 0.obs;
  Map<String, dynamic> orderInfo = {};

  getTotalPrice() {
    if (cart.isEmpty) {
      return;
    }

    cart.forEach((product) {
      int price = int.parse(product['price']) * int.parse(product['quantity']);
      totalPrice += price;
    });

    return totalPrice;
  }

  increaseQuantity(String productId, int price) {
    cart.forEach((product) {
      if (product['productId'] == productId) {
        product['quantity'] += 1;
      }
    });

    totalPrice += price;
  }

  decreaseQuantity(String productId, int price) {
    cart.forEach((product) {
      if (product['productId'] == productId) {
        product['quantity'] -= 1;
      }
    });

    totalPrice -= price;
  }

  // Add new Order
  addNewOrder() async {
    String id = randomAlphaNumeric(10);
    await DatabaseMethods().addNewOrder(orderInfo, id).then(
        (value) => Utils().showToastMessage("Order placed successfully", true));
  }
}
