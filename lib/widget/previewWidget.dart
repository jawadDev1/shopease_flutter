import 'package:flutter/material.dart';
import 'package:shopeease/widget/stars.dart';
import 'package:shopeease/widget/widget_support.dart';

class PreviewWidget extends StatefulWidget {
  PreviewWidget({
    super.key,
    required this.ProductCount,
    required this.title,
    required this.price,
    required this.stock,
  });

  final int? ProductCount;
  final String? title;
  final String? price;
  final num? stock;
  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  int? productCount;
  String? title;
  String? price;
  num? stock;

  @override
  void initState() {
    productCount = widget.ProductCount;
    title = widget.title;
    price = widget.price;
    stock = widget.stock;
    super.initState();
  }

  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context);

    return Container(
      width: ScreenSize.size.width * 0.90,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(11.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
              size: 28,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title',
                style: AppWidget.productTitleStyle(),
              ),
              Text(
                '$price',
                style: AppWidget.productTitleStyle(),
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
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
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
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 13),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14)),
                          child: Text(
                            '-',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "$productCount",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
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
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 13),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14)),
                          child: Text(
                            '+',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
