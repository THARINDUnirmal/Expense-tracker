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
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.issecurText && _obscure,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.labaleTexts,
        prefixIcon: Icon(widget.icon, color: AppColors.appGreenColor, size: 21),
        suffixIcon: widget.issecurText
            ? IconButton(
                tooltip: _obscure ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
      ),
    );
  }
}
