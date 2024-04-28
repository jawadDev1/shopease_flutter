import 'package:flutter/material.dart';
import 'package:shopeease/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // var ScreenSize = MediaQuery.of(context);
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Hello Whatever",
              style: AppWidget.boldTextStyle(),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(11.0)),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 26.0,
              ),
            )
          ]),
          SizedBox(
            height: 30.0,
          ),

          // Search And Filter Row

          SizedBox(
            height: 30.0,
          ),

          Text(
            "Categories",
            style: AppWidget.headingTextStyle(),
          ),
          SizedBox(
            height: 20.0,
          ),
          showCategories(),
        ],
      ),
    ));
  }

  // Categories Component
  Widget showCategories() {
    var ScreenSize = MediaQuery.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: ScreenSize.size.height * 0.24,
                  child: Image(
                    image: AssetImage('images/gun.jpg'),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 12.0,
                left: (ScreenSize.size.width * 0.20),
                child: Text(
                  "Guns",
                  style: AppWidget.categoryTextStyle(),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: ScreenSize.size.height * 0.24,
                  child: Image(
                    image: AssetImage('images/shoes.jpg'),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 12.0,
                left: (ScreenSize.size.width * 0.30),
                child: Text(
                  "Shoes",
                  style: AppWidget.categoryTextStyle(),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  height: ScreenSize.size.height * 0.24,
                  child: Image(
                    image: AssetImage('images/jet.jpg'),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 12.0,
                left: (ScreenSize.size.width * 0.30),
                child: Text(
                  "Jet",
                  style: AppWidget.categoryTextStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}













// Product Card

// import 'package:shopeease/widget/widget_support.dart';

// class ProductCard extends StatelessWidget {
//   const ProductCard({
//     super.key,
//     required this.ScreenSize,
//   });

//   final MediaQueryData ScreenSize;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//             clipBehavior: Clip.hardEdge,
//             height: ScreenSize.size.height * 0.44,
//             margin: EdgeInsets.only(left: 8.0, right: 12.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25.0),
//             ),
//             child: Image(
//               image: AssetImage('images/gun.jpg'),
//               fit: BoxFit.cover,
//             )),
//         Positioned(
//           bottom: 20.0,
//           left: 22.0,
//           child: Container(
//             width: ScreenSize.size.width * 0.36,
//             padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 14.0),
//             decoration: BoxDecoration(
//                 color: Color.fromRGBO(0, 0, 0, 0.6),
//                 borderRadius: BorderRadius.circular(11.0)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "\$120",
//                   style: AppWidget.cardTextStyle(),
//                 ),
//                 Icon(
//                   Icons.shopping_basket_outlined,
//                   color: Colors.white,
//                   size: 21.0,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
