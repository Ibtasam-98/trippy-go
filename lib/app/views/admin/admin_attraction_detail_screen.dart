import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import 'admin_add_attraction_screen.dart';

class AdminAttractionDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot attraction;

  AdminAttractionDetailScreen({required this.attraction});

  @override
  _AdminAttractionDetailScreenState createState() => _AdminAttractionDetailScreenState();
}

class _AdminAttractionDetailScreenState extends State<AdminAttractionDetailScreen> {
  String? expandedTile;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = (widget.attraction.data() as Map<String, dynamic>) ?? {};

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
                // 🖼 Attraction Image with Rounded Corners
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

                // 🔙 Back Button
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
                  // 📌 Attraction Name & Category
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

                  // 📌 Amenities Section (Now Includes Parking, Wheelchair, etc.)
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

                  _buildExpansionTile(
                    title: "Actions",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _confirmDelete,
                              child: CustomButton(
                                haveBgColor: true,
                                btnTitle: "Delete",
                                height: 45.h,
                                btnTitleColor: AppColors.white,
                                bgColor: AppColors.redDark,
                                borderRadius: 45.r,
                              ),
                            ),
                          ),
                          AppSizedBox.space10w,
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => AdminAddAttractionScreen(attraction: widget.attraction));
                              },
                              child: CustomButton(
                                haveBgColor: true,
                                btnTitle: "Edit",
                                height: 45.h,
                                btnTitleColor: AppColors.white,
                                bgColor: AppColors.blue,
                                borderRadius: 45.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    Get.defaultDialog(
      backgroundColor: AppColors.white,
      title: "Delete Attraction",
      titleStyle: TextStyle(
        fontFamily: 'grenda',
        fontSize: 15.sp,
      ),
      middleText: "Are you sure you want to delete this attraction?",
      middleTextStyle: TextStyle(
        fontFamily: 'quicksand',
        fontSize: 12.sp,
      ),
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.redDark,
      onConfirm: () async {
        try {
          await FirebaseFirestore.instance
              .collection('attractions')
              .doc(widget.attraction.id)
              .delete();

          Get.back(); // Close dialog
          Get.back(); // Go back to the previous screen

          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: 'Attraction deleted successfully!',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

        } catch (e) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: e.toString(),
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
    );
  }

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
