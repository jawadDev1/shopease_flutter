import 'package:flutter/material.dart';

Widget Stars(double rating) {
  List<Widget> stars = [];

  int filledStars = rating.floor();
  bool hasHalfStar = rating - filledStars >= 0.5;

  for (int i = 0; i < filledStars; i++) {
    stars.add(
      Icon(
        Icons.star,
        color: Colors.amber,
        size: 21.0,
      ),
    );
  }

  if (hasHalfStar) {
    stars.add(
      Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 21.0,
      ),
    );
    filledStars += 1;
  }

  for (int i = filledStars; i < 5; i++) {
    stars.add(
      Icon(
        Icons.star_border_outlined,
        color: Colors.amber,
        size: 21.0,
      ),
    );
  }
  return Row(
    children: stars,
  );
}
