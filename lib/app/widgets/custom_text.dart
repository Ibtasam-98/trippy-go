import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.fontWeight = FontWeight.normal,
    this.textColor,
    required this.fontSize,
    this.title,
    this.firstText,
    this.secondText,
    this.firstTextColor,
    this.secondTextColor,
    this.firstTextFontWeight,
    this.secondTextFontWeight,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maxLines,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.center,
    this.fontFamily,
    this.fontStyle = FontStyle.normal,
    this.isItalic = false,
    this.capitalize = false,
    this.isGlass = false,
    this.glassPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.textStyle,
  }) : assert(
  (title != null) ^ (firstText != null && secondText != null),
  'Provide either a single title or both firstText and secondText for dual-tone.',
  );

  final FontWeight fontWeight;
  final Color? textColor;
  final double fontSize;
  final String? title; // Single text mode
  final String? firstText; // Dual-tone first part
  final String? secondText; // Dual-tone second part
  final Color? firstTextColor;
  final Color? secondTextColor;
  final FontWeight? firstTextFontWeight;
  final FontWeight? secondTextFontWeight;
  final MainAxisAlignment mainAxisAlignment;
  final int? maxLines;
  final TextOverflow textOverflow;
  final TextAlign textAlign;
  final String? fontFamily;
  final FontStyle fontStyle;
  final bool isItalic;
  final bool capitalize;
  final bool isGlass;
  final EdgeInsetsGeometry glassPadding;
  final TextStyle? textStyle;

  /// Helper function to capitalize words
  String capitalizeTitle(String text) {
    return text
        .split(' ')
        .map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : word)
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = textStyle ??
        (fontFamily != null && fontFamily!.isNotEmpty
            ? TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          fontFamily: fontFamily,
        )
            : GoogleFonts.quicksand(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ));

    if (isItalic) {
      baseStyle = baseStyle.copyWith(fontStyle: FontStyle.italic);
    }

    Widget textWidget;

    if (title != null) {
      // **Single-tone text mode**
      textWidget = Text(
        capitalize ? capitalizeTitle(title!) : title!,
        overflow: textOverflow,
        maxLines: maxLines,
        textAlign: textAlign,
        style: baseStyle.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      );
    } else {
      // **Dual-tone text mode**
      textWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(
            firstText!,
            style: baseStyle.copyWith(
              fontSize: fontSize,
              fontWeight: firstTextFontWeight ?? fontWeight,
              color: firstTextColor ?? textColor,
            ),
          ),
          Text(
            secondText!,
            style: baseStyle.copyWith(
              fontSize: fontSize,
              fontWeight: secondTextFontWeight ?? fontWeight,
              color: secondTextColor ?? textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    if (isGlass) {
      return IntrinsicWidth(
        child: GlassContainer(
          color: AppColors.white.withOpacity(0.1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.blue.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(10.r),
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
            padding: glassPadding,
            child: Center(child: textWidget),
          ),
        ),
      );
    }

    return textWidget;
  }
}
