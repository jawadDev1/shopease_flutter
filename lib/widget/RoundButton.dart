import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;
  const RoundButton(
      {super.key,
      required this.title,
      required this.color,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize:
              Size(ScreenSize.size.width * 0.8, ScreenSize.size.height * .06),
        ),
        onPressed: onTap,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  "$title",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
        ));
  }
}
