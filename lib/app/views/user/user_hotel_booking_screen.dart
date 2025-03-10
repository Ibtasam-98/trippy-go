import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import '../../config/app_colors.dart';
import '../../controllers/user/user_hotel_booking_screen_controller.dart';
import '../../widgets/custom_button.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class UserHotelBookingScreen extends StatelessWidget {
  final String hotelId;
  final String hotelName;

  UserHotelBookingScreen({super.key, required this.hotelId, required this.hotelName});

  final UserHotelBookingController controller = Get.put(UserHotelBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: AppColors.white,
        title: CustomText(
          firstText: "Book",
          secondText: " Hotel",
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'Nationality',
                isPassword: false,
                textEditingController: controller.nationalityController,
                validator: controller.validateNationality,
              ),
              CustomTextField(
                label: 'Check-in Date',
                isPassword: false,
                textEditingController: controller.checkInController,
                validator: (value) => value!.isEmpty ? 'Select Check-in Date' : null,
                onChanged: (_) => controller.selectDate(controller.checkInController, context),
              ),
              CustomTextField(
                label: 'Check-out Date',
                isPassword: false,
                textEditingController: controller.checkOutController,
                validator: (value) => value!.isEmpty ? 'Select Check-out Date' : null,
                onChanged: (_) => controller.selectDate(controller.checkOutController, context),
              ),
              CustomTextField(
                label: 'Number of Guests',
                isPassword: false,
                textEditingController: controller.guestsController,
                keyboardType: TextInputType.number,
                validator: controller.validateGuests,
              ),
              CustomDropdown(
                hint: 'Select Room Type',
                items: ['Single', 'Double', 'Suite'],
                selectedValue: controller.roomType,
              ),
              CustomDropdown(
                hint: 'Meal Preference',
                items: ['Vegetarian', 'Vegan', 'Non-Vegetarian'],
                selectedValue: controller.mealPreference,
              ),
              Obx(() => CheckboxListTile(
                title: CustomText(
                  title:'Airport Pickup/Drop-off',
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,
                ),
                value: controller.airportPickup.value,
                onChanged: (value) => controller.airportPickup.value = value!,
              )),
              Obx(() => CheckboxListTile(
                title: CustomText(
                  title:'Car Rental',
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,),
                value: controller.carRental.value,
                onChanged: (value) => controller.carRental.value = value!,
              )),
              AppSizedBox.space15h,
              Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: AppColors.primary,))
                  : InkWell(
                onTap: () => controller.bookHotel(hotelId, hotelName),
                child: CustomButton(
                  haveBgColor: true,
                  btnTitle: 'Submit',
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 15.r,
                  height: 45.h,
                ),
              )),

            ],
          ),
        ),
      ),
    );
  }
}