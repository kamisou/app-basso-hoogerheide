import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    this.validator,
    this.obscureText = false,
  });

  final TextEditingController? controller;

  final IconData? prefixIcon;

  final String? hintText;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final bool obscureText;

  final VoidCallback? onEditingComplete;

  final String? Function(String?)? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon:
            widget.prefixIcon != null ? const Icon(Icons.lock_outline) : null,
        hintText: widget.hintText,
        suffixIcon: widget.obscureText
            ? GestureDetector(
                onTap: () => setState(() => _obscured = !_obscured),
                child: Icon(_obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
              )
            : null,
      ),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscured,
      onEditingComplete: widget.onEditingComplete,
      validator: widget.validator,
    );
  }
}
