import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_colors.dart';
class CustomDropdown extends StatelessWidget {
  final String hint; // Updated from title to hint
  final List<String> items;
  final RxString selectedValue;

  const CustomDropdown({
    super.key,
    required this.hint, // Changed parameter name to hint
    required this.items,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Obx(
              () => InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.black.withOpacity(0.1), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.black.withOpacity(0.1), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.black.withOpacity(0.1), width: 1),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: AppColors.white,
                value: selectedValue.value.isNotEmpty ? selectedValue.value : null,
                isExpanded: true,
                style: GoogleFonts.quicksand(color: AppColors.black),
                hint: Text(
                  hint, // Hint text inside the dropdown
                  style: GoogleFonts.quicksand(color: AppColors.black, fontSize: 12.sp),
                ),
                items: items
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedValue.value = value;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
