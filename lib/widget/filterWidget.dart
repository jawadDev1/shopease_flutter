import 'package:flutter/material.dart';
import 'package:shopeease/screens/listProducts.dart';
import 'package:shopeease/utils/theme.dart';
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

  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();

  @override
  void initState() {
    scrollController = widget.scrollController;
    bottomSheetOffset = widget.bottomSheetOffset;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: ListView(
          padding: const EdgeInsets.all(16),
          controller: scrollController,
          children: [
            Text(
              "Filters",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Price Range",
              style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: minPriceController..text = "0",
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '0',
                          hintStyle: TextStyle(color: AppTheme.white)),
                    ),
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: maxPriceController..text = "1500000",
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '150000',
                          hintStyle: TextStyle(color: AppTheme.white)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 22,
            ),
            RoundButton(
                title: "Apply",
                color: AppTheme.primary,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListProducts(
                                isSearched: false,
                                minPrice: minPriceController.text,
                                maxPrice: maxPriceController.text,
                              )));
                })
          ]),
    );
  }
}
