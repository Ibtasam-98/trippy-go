import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trippygo/app/config/app_colors.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import 'package:get/get.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_button.dart'; // Assuming CustomButton is already defined

class UserHotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;

  // Constructor to receive the hotel data
  UserHotelDetailScreen({required this.hotel});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> amenities = hotel['amenities'] ?? {}; // Amenities data
    List<dynamic> reviews = hotel['reviews'] ?? []; // Reviews data

    // ValueNotifier to track the expanded state for each section
    ValueNotifier<bool> descriptionExpanded = ValueNotifier(false);
    ValueNotifier<bool> amenitiesExpanded = ValueNotifier(false);
    ValueNotifier<bool> reviewsExpanded = ValueNotifier(false);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Hotel Image with Rounded Corners
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.r),
                    bottomRight: Radius.circular(25.r),
                  ),
                  child: Image.asset(
                    "assets/images/hotel_placeholder.jpg",
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 30.h,
                  left: 20.w,
                  child: IconButton(
                    icon: Icon(
                      Icons.west,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                  ),
                ),
                Positioned(
                  top: 30.h,
                  right: 20.w,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.heart,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            AppSizedBox.space10h,
            Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          title: hotel['name'],
                          fontFamily: 'grenda',
                          fontWeight: FontWeight.bold,
                          textColor: AppColors.black,
                          textAlign: TextAlign.start,
                          capitalize: true,
                          fontSize: 20.sp,
                        ),
                      ),
                      Row(
                        children: [
                          CustomText(
                            title: hotel['category'].toString().split('-')[0],
                            fontSize: 18.sp,
                            textColor: AppColors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'grenda',
                          ),
                          AppSizedBox.space5w,
                          Icon(Icons.star, color: AppColors.primary, size: 17.h),
                        ],
                      ),
                    ],
                  ),
                  Divider(thickness: 0.1, color: AppColors.black),

                  _buildExpansionTile(
                    title: "Description",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          title: hotel['description'] ?? "No description available.",
                          fontSize: 14.sp,
                          capitalize: true,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black.withOpacity(0.7),
                          maxLines: 20,
                        ),
                      ),
                    ),
                    expansionNotifier: descriptionExpanded,
                  ),

                  // Amenities Section
                  _buildExpansionTile(
                    title: "Amenities",
                    content: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: amenities.entries
                          .where((entry) => entry.value == true)
                          .map((entry) => Chip(
                        label: CustomText(
                          title: entry.key,
                          fontSize: 12.sp,
                          textColor: AppColors.black,
                          textAlign: TextAlign.start,
                        ),
                        backgroundColor: AppColors.white,
                      ))
                          .toList(),
                    ),
                    expansionNotifier: amenitiesExpanded,
                  ),

                  // Reviews Section
                  _buildExpansionTile(
                    title: "Reviews",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: reviews.isEmpty
                            ? CustomText(
                          title: "No reviews available yet.",
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black.withOpacity(0.7),
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reviews
                              .map<Widget>((review) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: CustomText(
                              title: review,
                              fontSize: 14.sp,
                              textAlign: TextAlign.start,
                              textColor: AppColors.black.withOpacity(0.7),
                            ),
                          ))
                              .toList(),
                        ),
                      ),
                    ),
                    expansionNotifier: reviewsExpanded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add Booking Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Handle Add Booking action
                  },
                  child: CustomButton(
                    haveBgColor: true,
                    btnTitle: "Add Booking",
                    height: 45.h,
                    btnTitleColor: AppColors.white,
                    bgColor: AppColors.primary,
                    borderRadius: 45.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required Widget content,
    required ValueNotifier<bool> expansionNotifier,
  }) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: expansionNotifier,
          builder: (context, isExpanded, child) {
            return ExpansionTile(
              shape: Border.all(color: AppColors.transparent),
              title: CustomText(
                title: title,
                fontSize: 16.sp,
                fontFamily: 'grenda',
                fontWeight: FontWeight.bold,
                textColor: AppColors.black,
                textAlign: TextAlign.start,
              ),
              trailing: Image.asset(
                isExpanded
                    ? "assets/images/minus.png"
                    : "assets/images/add.png",
                width: 20.w,
                height: 20.h,
              ),
              children: [content],
              onExpansionChanged: (expanded) {
                expansionNotifier.value = expanded;
              },
            );
          },
        ),
        Divider(color: AppColors.black, thickness: 0.1),
      ],
    );
  }
}
