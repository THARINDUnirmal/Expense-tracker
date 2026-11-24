import 'package:flutter/material.dart';

class CustomTextForm2 extends StatelessWidget {
  final TextInputType? keyboardType;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextForm2({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(labelText: hintText),
      ),
    );
  }
}
