import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/widgets/custom_dropdown.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../controllers/admin/admin_add_hotel_screen_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class AddHotelScreen extends StatelessWidget {
  final QueryDocumentSnapshot? hotel;
  final AdminAddHotelScreenController controller = Get.put(AdminAddHotelScreenController());

  AddHotelScreen({super.key, this.hotel}) {
    controller.initializeHotel(hotel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: AppColors.white,
        title: CustomText(
          firstText: hotel == null ? "Add" : "Edit",
          secondText: " Hotel",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 15.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left:12.w,right: 12.w),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard("Hotel Details", [
                  _buildTextField(controller.nameController, "Hotel Name"),
                  _buildTextField(controller.cityController, "City Name"),
                  _buildTextField(controller.addressController, "Hotel Address"),
                  _buildTextField(controller.descriptionController, "Hotel Description", maxLines: 3),
                  _buildTextField(controller.contactController, "Contact Number", keyboardType: TextInputType.phone),
                ]),
                AppSizedBox.space10h,
                _buildCard("Select Category", [
                  CustomDropdown(
                      hint:"Hotel Category",
                      items:["3-Star", "4-Star", "5-Star"],
                      selectedValue: controller.selectedCategory),
                ]),
                AppSizedBox.space10h,
                _buildCard("Facilities & Amenities", [
                  Obx(() => Column(
                    children: controller.amenities.keys.map((key) {
                      return CheckboxListTile(
                        checkColor: AppColors.white,
                        activeColor: AppColors.primary,
                        title: CustomText(title: key, fontSize: 13.sp, textAlign: TextAlign.start),
                        value: controller.amenities[key],
                        onChanged: (value) => controller.amenities[key] = value!,
                      );
                    }).toList(),
                  )),
                ]),
                AppSizedBox.space20h,
                _buildCard("Room Details", [
                  CustomDropdown(
                      hint:"Room Type",
                      items:["Single", "Double", "Suite", "Family"],
                      selectedValue:  controller.selectedRoomType),
                  CustomDropdown(
                      hint: "Bed Option",
                      items: ["King", "Queen", "Twin"],
                      selectedValue:  controller.selectedBedOption,
                  ),
                  _buildTextField(controller.priceController, "Price Per Night", keyboardType: TextInputType.number),
                ]),
                AppSizedBox.space20h,
                Obx(() => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator(color: AppColors.primary,))
                    : InkWell(
                  onTap: () => controller.submitHotel(hotel),
                  child: CustomButton(
                    haveBgColor: true,
                    btnTitle: 'Submit',
                    btnTitleColor: AppColors.white,
                    bgColor: AppColors.primary,
                    borderRadius: 15.r,
                    height: 45.h,
                  ),
                )),
                AppSizedBox.space50h,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false, TextInputType keyboardType = TextInputType.text, int? maxLines}) {
    return CustomTextField(
      label: label,
      isPassword: isPassword,
      textEditingController: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      borderColor: AppColors.black.withOpacity(0.1),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        if (label == "City Name" && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
          return "City Name can only contain alphabetic characters";
        }
        if (label == "Contact Number" && !RegExp(r'^\+?\d{1,4}(\s?\d{1,15})?$').hasMatch(value.trim())) {
          return "Contact Number should be a valid format (e.g. +1 1234567890)";
        }
        if (label == "Price Per Night") {
          String cleanValue = value.trim().replaceAll(RegExp(r'[^\d.]'), '');
          if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(cleanValue)) {
            return "Price must be a valid number";
          }
        }
        return null;
      },
    );
  }





  Widget _buildCard(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'grenda',
        ),
        ...children,
      ],
    );
  }
}

