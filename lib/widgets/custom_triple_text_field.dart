import 'package:flutter/material.dart';

class CustomTripleTextField extends StatelessWidget {
  const CustomTripleTextField({
    Key? key,
    required this.controller1,
    required this.onChanged1,
    required this.label1,
    required this.suffix1,
    required this.controller2,
    required this.onChanged2,
    required this.label2,
    required this.suffix2,
    required this.controller3,
    required this.onChanged3,
    required this.label3,
    required this.suffix3,
  }) : super(key: key);

  final String label1;
  final TextEditingController controller1;
  final void Function(String value) onChanged1;
  final String? suffix1;
  final String label2;
  final TextEditingController controller2;
  final void Function(String value) onChanged2;
  final String? suffix2;
  final String label3;
  final TextEditingController controller3;
  final void Function(String value) onChanged3;
  final String? suffix3;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Text(label1),
          Flexible(
            child: TextField(
              controller: controller1,
              onChanged: onChanged1,
              style: const TextStyle(color: Colors.deepOrange),
            ),
          ),
          Visibility(
            visible: suffix1 != null,
            child: Text(suffix1 ?? ''),
          ),
          const VerticalDivider(),
          Text(label2),
          Flexible(
            child: TextField(
              controller: controller2,
              onChanged: onChanged2,
              style: const TextStyle(color: Colors.deepOrange),
            ),
          ),
          Visibility(
            visible: suffix2 != null,
            child: Text(suffix2 ?? ''),
          ),
          const VerticalDivider(),
          Text(label3),
          Flexible(
            child: TextField(
              controller: controller3,
              onChanged: onChanged3,
              style: const TextStyle(color: Colors.deepOrange),
            ),
          ),
          Visibility(
            visible: suffix3 != null,
            child: Text(suffix3 ?? ''),
          ),
        ],
      ),
    );
  }
}
