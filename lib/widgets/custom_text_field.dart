import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    this.suffix,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final String? suffix;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Flexible(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.deepOrange),
          ),
        ),
        Visibility(
          visible: suffix != null,
          child: Text(suffix ?? ''),
        ),
      ],
    );
  }
}
