import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({
    super.key,
    this.height,
    this.width,
    this.child,
  });
  final double? height;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Controls the shadow depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      child: SizedBox(
        height: height, // Set your desired height
        width: width, // Set your desired width
        child: child,
      ),
    );
  }
}
