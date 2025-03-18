import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import '../../config/app_colors.dart';
import '../../controllers/admin/admin_add_attraction_screen_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';

class AdminAddAttractionScreen extends StatelessWidget {
  final dynamic attraction;

  const AdminAddAttractionScreen({Key? key, this.attraction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminAttractionController controller = Get.put(AdminAttractionController());

    if (attraction != null) {
      controller.setAttractionData(attraction);
    } else {
      controller.resetForm();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.white,
        title: CustomText(
          firstText: attraction != null ? "Edit" : "Add",
          secondText: " Attraction",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 15.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: "Attraction Name",
                isPassword: false,
                textEditingController: controller.attractionNameController,
                validator: (value) => controller.validateAlphabetic(value, "Attraction Name"),
              ),
              AppSizedBox.space5h,
              CustomText(
                fontSize: 15.sp,
                title: 'Category',
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space5h,
              CustomDropdown(
                hint: "Category",
                items: const ["Park", "Beach", "Museum", "Adventure"],
                selectedValue: controller.selectedCategory, // Corrected
              ),
              AppSizedBox.space5h,
              CustomTextField(
                label: "Description",
                isPassword: false,
                textEditingController: controller.descriptionController,
                maxLines: 3,
              ),
              CustomTextField(
                label: "City",
                isPassword: false,
                textEditingController: controller.cityController,
                validator: (value) => controller.validateAlphabetic(value, "City"),
              ),
              CustomTextField(
                label: "Opening Hours",
                isPassword: false,
                textEditingController: controller.openingHoursController,
                validator: (value) => value!.isEmpty ? "Select opening hours" : null,
                onChanged: (_) => controller.selectOpeningHours(context),
              ),
              CustomTextField(
                label: "Entry Fee (Optional)",
                isPassword: false,
                textEditingController: controller.entryFeeController,
                keyboardType: TextInputType.number,
                validator: (value) => controller.validateNumeric(value, "Entry Fee"),
              ),
              AppSizedBox.space5h,
              CustomText(
                fontSize: 15.sp,
                title: 'Parking Availability',
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space5h,
              CustomDropdown(
                hint: "Parking Availability",
                items: const ["Yes", "No"],
                selectedValue: controller.selectedParking, // Corrected
              ),
              AppSizedBox.space5h,
              CustomText(
                fontSize: 15.sp,
                title: 'Public Transport Access',
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space5h,
              CustomDropdown(
                hint: "Public Transport Access",
                items: const ["Bus", "Metro", "None"],
                selectedValue: controller.selectedPublicTransport, // Corrected
              ),
              AppSizedBox.space5h,
              CustomText(
                fontSize: 15.sp,
                title: 'Wheelchair Accessibility',
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space5h,
              CustomDropdown(
                hint: "Wheelchair Accessibility",
                items: const ["Yes", "No"],
                selectedValue: controller.selectedWheelchair, // Corrected
              ),
              AppSizedBox.space5h,
              CustomText(
                fontSize: 15.sp,
                title: 'Best Season',
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space5h,
              CustomDropdown(
                hint: "Best Season to Visit",
                items: const ["Summer", "Winter", "All Year"],
                selectedValue: controller.selectedSeason, // Corrected
              ),
              SizedBox(height: 20.h),
              Obx(
                    () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                  onTap: () => controller.saveOrUpdateAttraction(Get.context!, attraction),
                  child: CustomButton(
                    btnTitle: attraction != null ? "Update Attraction" : "Save Attraction",
                    haveBgColor: true,
                    bgColor: AppColors.primary,
                    btnTitleColor: AppColors.white,
                    borderRadius: 45.r,
                    height: 45.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final RxnString selectedValue; // Modified to RxnString

  const CustomDropdown({
    Key? key,
    required this.hint,
    required this.items,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonFormField<String>(
      decoration: InputDecoration(
        // labelText: hint,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      value: selectedValue.value, // Access the nullable value
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        selectedValue.value = newValue; // Update the nullable value
      },
    ));
  }
}