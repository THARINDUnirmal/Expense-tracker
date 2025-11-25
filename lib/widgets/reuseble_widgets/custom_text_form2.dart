import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextForm2 extends StatefulWidget {
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
  State<CustomTextForm2> createState() => _CustomTextForm2State();
}

class _CustomTextForm2State extends State<CustomTextForm2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        validator: widget.validator,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: AppColors.appGreenColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
        ),
      ),
    );
  }
}
