import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {Key? key, required this.child, this.width, this.height})
      : super(key: key);
  final double? width;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.1),
        border: Border.all(color: Colors.deepOrange, width: 2),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
