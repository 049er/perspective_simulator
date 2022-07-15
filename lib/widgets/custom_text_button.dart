import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
        child: Text(label),
      ),
    );
  }
}
