import 'package:flutter/material.dart';
import 'package:shopeease/utils/theme.dart';
import 'package:shopeease/widget/stars.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.Name,
    required this.Rating,
    required this.Comment,
  });

  final String Name;
  final double Rating;
  final String Comment;

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context);
    return Container(
      width: ScreenSize.size.width * .80,
      height: ScreenSize.size.height * .16,
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "$Name",
          style: TextStyle(
              fontSize: 17,
              fontFamily: "Roboto-Regular",
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        SizedBox(
          height: 2,
        ),
        Stars(3.5),
        SizedBox(
          height: 2,
        ),
        Text(
          "$Comment",
          maxLines: 2,
          style: TextStyle(
              fontSize: 13, fontFamily: "Roboto-Regular", color: Colors.white),
        ),
      ]),
    );
  }
}
