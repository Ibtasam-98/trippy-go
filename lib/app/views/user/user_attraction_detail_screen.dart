import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class UserAttractionDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot attraction;

  UserAttractionDetailScreen({required this.attraction});

  @override
  _UserAttractionDetailScreenState createState() =>
      _UserAttractionDetailScreenState();
}

class _UserAttractionDetailScreenState extends State<UserAttractionDetailScreen> {
  String? expandedTile;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        (widget.attraction.data() as Map<String, dynamic>) ?? {};

    // Retrieve data from Firestore
    String parking = data['parking'] ?? "Not available";
    String wheelchairAccess = data['wheelchair_access'] ?? "Not available";
    String publicTransport = data['public_transport'] ?? "Not available";
    String bestSeason = data['best_season'] ?? "Not available";

    Map<String, String> amenities = {
      "Parking": parking,
      "Wheelchair Access": wheelchairAccess,
      "Public Transport": publicTransport,
      "Best Season": bestSeason,
    };

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Attraction Image with Rounded Corners
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: Image(
                    image: AssetImage("assets/images/attraction.jpg"),
                    fit: BoxFit.cover,
                    height: 200.h,
                    width: double.infinity,
                  ),
                ),

                // Back Button
                Positioned(
                  top: 40.h,
                  left: 15.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.west,
                      color: AppColors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attraction Name & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          title: data['spot_name'] ?? "Unknown",
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
                            title: data['category'] ?? "Uncategorized",
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

                  // Amenities Section
                  _buildExpansionTile(
                    title: "Amenities",
                    content: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: amenities.entries.map((entry) {
                        return Chip(
                          label: CustomText(
                            title: "${entry.key}: ${entry.value}",
                            fontSize: 12.sp,
                            textColor: AppColors.black,
                            textAlign: TextAlign.start,
                          ),
                          backgroundColor: AppColors.white,
                        );
                      }).toList(),
                    ),
                  ),

                  // Description Section
                  _buildExpansionTile(
                    title: "Description",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          title: data['description'] ?? "No description available",
                          fontSize: 14.sp,
                          capitalize: true,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black.withOpacity(0.7),
                          maxLines: 20,
                        ),
                      ),
                    ),
                  ),

                  // Reviews Section
                  _buildExpansionTile(
                    title: "Reviews",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          title: "No reviews available yet.",
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
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


  // ExpansionTile builder
  Widget _buildExpansionTile({required String title, required Widget content}) {
    bool isExpanded = expandedTile == title;

    return Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          shape: Border.all(color: AppColors.transparent),
          title: CustomText(
            title: title,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            fontWeight: FontWeight.bold,
            textColor: AppColors.black,
            textAlign: TextAlign.start,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              expandedTile = expanded ? title : null;
            });
          },
          children: [content],
        ),
        if (!isExpanded) Divider(color: AppColors.black, thickness: 0.1),
      ],
    );
  }
}
