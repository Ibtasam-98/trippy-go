import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../controllers/admin/admin_add_attraction_screen_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';

class AdminAddAttractionScreen extends StatelessWidget {
  final dynamic attraction;
  AdminAddAttractionScreen({Key? key, this.attraction}) : super(key: key);

  final AdminAttractionController controller = Get.put(AdminAttractionController());

  @override
  Widget build(BuildContext context) {
    if (attraction != null) {
      controller.setAttractionData(attraction);
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
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
          icon: Icon(Icons.arrow_back, color: AppColors.black),
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
                label: "Spot Name",
                isPassword: false,
                textEditingController: controller.spotNameController,
                validator: (value) => controller.validateAlphabetic(value, "Spot Name"),
              ),

              CustomDropdown(
                hint: "Category",
                items: ["Park", "Beach", "Museum", "Adventure"],
                selectedValue: controller.selectedCategory,
              ),

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

              CustomDropdown(
                hint: "Parking Availability",
                items: ["Yes", "No"],
                selectedValue: controller.selectedParking,
              ),

              CustomDropdown(
                hint: "Public Transport Access",
                items: ["Bus", "Metro", "None"],
                selectedValue: controller.selectedPublicTransport,
              ),

              CustomDropdown(
                hint: "Wheelchair Accessibility",
                items: ["Yes", "No"],
                selectedValue: controller.selectedWheelchair,
              ),

              CustomDropdown(
                hint: "Best Season to Visit",
                items: ["Summer", "Winter", "All Year"],
                selectedValue: controller.selectedSeason,
              ),

              SizedBox(height: 20),

              Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                onTap: () => controller.saveOrUpdateAttraction(
                  Get.context!, // Pass the context
                  attraction,
                ),
                child: CustomButton(
                  btnTitle: attraction != null ? "Update Attraction" : "Save Attraction",
                  haveBgColor: true,
                  bgColor: AppColors.primary,
                  btnTitleColor: AppColors.white,
                  borderRadius: 45.r,
                  height: 45.r,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
