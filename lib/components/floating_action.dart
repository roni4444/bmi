import 'package:flutter/material.dart';

class FloatingAction extends StatelessWidget {
  const FloatingAction({Key? key, required this.label, this.function})
      : super(key: key);

  final String label;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: null,
      backgroundColor: const Color(0xFFEB1555),
      onPressed: function,
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
