import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/widget/expandedWidget.dart';
import 'package:shopeease/widget/previewWidget.dart';
import 'package:shopeease/widget/widget_support.dart';

class Details extends StatefulWidget {
  const Details({
    super.key,
    required this.title,
    required this.image,
    required this.descirption,
    required this.price,
    required this.stock,
    required this.sizes,
    required this.colors,
  });

  final String title;
  final String image;
  final String descirption;
  final String price;
  final String stock;
  final String sizes;
  final String colors;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int productCount = 1;
  String size = 'S';
  String color = '';
  String? title;
  String? image;
  String? descirption;
  String? price;
  String? stock;
  String? sizes;
  String? colors;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    image = widget.image;
    descirption = widget.descirption;
    price = widget.price;
    stock = widget.stock;
    sizes = widget.sizes;
    colors = widget.colors;
  }

  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context);
    return Scaffold(
      // Bottom Sheet
      body: DraggableBottomSheet(
          minExtent: 150,
          useSafeArea: false,
          curve: Curves.easeIn,
          maxExtent: ScreenSize.size.height * 0.8,
          previewWidget: PreviewWidget(
            ProductCount: productCount,
            title: title,
            price: price,
            stock: int.parse(stock!),
          ),
          backgroundWidget: _backgroundWidget(
            ScreenSize: ScreenSize,
            image: image,
          ),
          expandedWidget: ExpandedWidget(
            ProductCount: productCount,
            size: size,
            title: title,
            stock: int.parse(stock!),
            description: descirption,
            productSizes: sizes,
            productColors: colors,
            color: color,
          ),
          onDragging: (pos) {}),
    );
  }
}

// BackGround Widget
class _backgroundWidget extends StatelessWidget {
  const _backgroundWidget(
      {super.key, required this.ScreenSize, required this.image});

  final MediaQueryData ScreenSize;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.size.height,
      width: ScreenSize.size.width,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 11),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image!),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.7, color: Colors.white),
                  borderRadius: BorderRadius.circular(21.0)),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
