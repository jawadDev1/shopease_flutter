import 'package:flutter/material.dart';
import 'package:shopeease/widget/RoundButton.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    required this.scrollController,
    required this.bottomSheetOffset,
  });
  final ScrollController scrollController;
  final double bottomSheetOffset;
  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late ScrollController scrollController;
  late double bottomSheetOffset;

  TextEditingController startPrice = TextEditingController();
  TextEditingController finalPrice = TextEditingController();

  @override
  void initState() {
    scrollController = widget.scrollController;
    bottomSheetOffset = widget.bottomSheetOffset;
    super.initState();
  }

  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context);
    return ListView(
        padding: const EdgeInsets.all(16),
        controller: scrollController,
        children: [
          Text(
            "Filters",
            style: TextStyle(
                fontSize: 28,
                fontFamily: 'Montserrat-Regular',
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            "Price Range",
            style: TextStyle(
                fontSize: 21,
                fontFamily: 'Montserrat-Regular',
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startPrice,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '0',
                    ),
                  ),
                ),
                SizedBox(
                  width: 22,
                ),
                Expanded(
                  child: TextField(
                    controller: finalPrice,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: '150000'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 22,
          ),
          RoundButton(title: "Apply", color: Colors.black, onTap: () {})
        ]);
  }
}
