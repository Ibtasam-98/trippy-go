import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final bool isPassword;
  final String label;
  final IconData? icon;
  final TextEditingController textEditingController;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? prefixIconSize;
  final double? hintFontSize;
  final EdgeInsetsGeometry? contentPadding; // NEW PARAMETER
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.isPassword,
    this.icon,
    required this.textEditingController,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.prefixIconSize,
    this.hintFontSize,
    this.contentPadding, // Add new parameter
    this.onChanged,
    this.focusNode,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Theme(
        data: ThemeData(
          hintColor: Colors.black,
        ),
        child: TextFormField(
          focusNode: widget.focusNode,
          obscureText: widget.isPassword ? _obscureText : false,
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          maxLines: widget.maxLines ?? 1,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, size: widget.prefixIconSize ?? 14.h)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: 16.h,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor ?? Colors.transparent,
            hintText: widget.label,
            contentPadding: widget.contentPadding ?? EdgeInsets.all(10.h), // Uses the new parameter
            hintStyle: GoogleFonts.quicksand(
              fontSize: widget.hintFontSize ?? 10.h,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
              borderSide: BorderSide(color: widget.borderColor ?? Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
              borderSide: BorderSide(color: widget.borderColor ?? Colors.black),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
