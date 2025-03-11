import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import 'package:trippygo/app/widgets/custom_button.dart';

import '../../config/app_colors.dart';
import '../../controllers/user/user_add_attraction_booking_screen.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class UserAddAttractionBookingScreen extends StatelessWidget {
  final String attractionName;
  final String attractionID;
  final AttractionBookingController controller = Get.put(AttractionBookingController());

  UserAddAttractionBookingScreen({required this.attractionID, required this.attractionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: AppColors.white,
        title: CustomText(
          firstText: "Book",
          secondText: " Attraction",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 18.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              textEditingController: controller.nationalityController,
              label: 'Nationality',
              keyboardType: TextInputType.text,
              isPassword: false,
            ),
            AppSizedBox.space10h,
            GestureDetector(
              onTap: () => controller.selectCheckInTime(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: controller.checkInTimeController,
                  decoration: InputDecoration(
                      labelText: 'Check-in Time',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.black26),
                    ),

                  ),
                ),
              ),
            ),
            AppSizedBox.space10h,
            CustomTextField(
              textEditingController: controller.numberOfGuestsController,
              label: 'Number of Guests',
              keyboardType: TextInputType.number,
              isPassword: false,
            ),
            AppSizedBox.space10h,
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.additionalService.value,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    controller.additionalService.value = value!;
                  },
                )),
                CustomText(
                    title:"Additional Service",
                  fontSize: 15.sp,
                )
              ],
            ),
            AppSizedBox.space20h,
            Obx(() => controller.isLoading.value
                ? Center(
              child: CircularProgressIndicator(),
            )
                : InkWell(
              onTap: (){
                controller.bookAttraction(attractionName, attractionID, context);
              },
                  child: CustomButton(
                    haveBgColor: true,
                    height: 45.h,
                    btnTitle: "Submit",
                    btnTitleColor: Colors.white,
                    bgColor: AppColors.primary,
                    borderRadius: 25,
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}