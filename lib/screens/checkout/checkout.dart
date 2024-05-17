import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/instance_manager.dart';
import 'package:shopeease/controllers/cart_controller.dart';
import 'package:shopeease/screens/checkout/payment.dart';
import 'package:shopeease/utils/Utils.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/RoundButton.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final CartController cartController = Get.put(CartController());

  Map<String, dynamic>? paymentIntent;

  Future displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await cartController.addNewOrder();
    } catch (e) {
      Utils().showToastMessage("Make payment to place order", false);
    }
  }

  Future makePayment() async {
    paymentIntent =
        await createPaymentIntent(cartController.totalPrice.toString());

    var gpay = PaymentSheetGooglePay(
        merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
            customerId: paymentIntent!['id'],
            merchantDisplayName: "Kakashi",
            googlePay: gpay));

    await displayPaymentSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: AppTheme.white, size: 26.0),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartController.cart.length,
              itemBuilder: (context, index) {
                var product = cartController.cart[index];
                return CheckoutCard(
                    title: product['title'],
                    quantity: product['quantity'],
                    image: product['image']);
              },
            ),
          ),
          Material(
              elevation: 5.0,
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Total: \$${cartController.totalPrice}",
                    style: TextStyle(
                        fontSize: 19,
                        color: AppTheme.white,
                        fontFamily: "Roboto-Regular",
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 12.0),
                    child: RoundButton(
                        title: "Pay",
                        color: AppTheme.primary,
                        onTap: () async {
                          await makePayment();
                        }),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.image,
  });

  final String title;
  final int quantity;
  final String image;

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
                    width: screenSize.size.width * 0.22,
                    height: screenSize.size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Image(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${title}",
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 17.0,
                            fontFamily: "Montserrat-Regular",
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Quantity: ${quantity}",
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 17.0,
                            fontFamily: "Montserrat-Regular",
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
