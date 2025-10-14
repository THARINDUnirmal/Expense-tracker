import 'package:expenzes/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final bool issecurText;
  final TextEditingController controller;
  final String labaleTexts;
  final IconData icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labaleTexts,
    required this.icon,
    required this.issecurText,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.grey.withOpacity(0.5),
            offset: Offset(15, 15),
          ),
          BoxShadow(blurRadius: 1, color: Colors.white, offset: Offset(-5, 0)),
        ],
      ),
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.issecurText ? true : false,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.labaleTexts,
          hintStyle: TextStyle(color: AppColors.appBlackColor),
          prefixIcon: Icon(
            widget.icon,
            color: AppColors.appBlueColor,
            size: 30,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
