import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/widgets/custom_button.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_text.dart';
import 'admin_add_hotel_screen.dart';

class AdminHotelDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot hotel;
  final String imagePath; // Added imagePath parameter

  AdminHotelDetailScreen({required this.hotel, required this.imagePath});

  @override
  _AdminHotelDetailScreenState createState() => _AdminHotelDetailScreenState();
}

class _AdminHotelDetailScreenState extends State<AdminHotelDetailScreen> {
  String? expandedTile;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> amenities = widget.hotel['amenities'];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: Image(
                    image: AssetImage(widget.imagePath), // Use provided image path
                    fit: BoxFit.fill,
                    height: 200.h,
                    width: double.infinity,
                  ),
                ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          title: widget.hotel['name'],
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
                            title: widget.hotel['category'].toString().split('-')[0],
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
                  ),
                  _buildExpansionTile(
                    title: "Description",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          title: widget.hotel['description'],
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
                              onTap: () {
                                _confirmDelete();
                              },
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
                                Get.to(() => AddHotelScreen(hotel: widget.hotel));
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
                          )
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
      title: "Delete Hotel",
      titleStyle: TextStyle(
        fontFamily: 'grenda',
        fontSize: 15.sp,
      ),
      middleText: "Are you sure you want to delete this hotel?",
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
              .collection('hotels')
              .doc(widget.hotel.id)
              .delete();

          Get.back();
          Get.back();

          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: 'Hotel deleted successfully!',
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
          trailing: Image.asset(
            isExpanded ? "assets/images/minus.png" : "assets/images/add.png",
            width: 20.w,
            height: 20.h,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              expandedTile = expanded ? title : null;
            });
          },
          children: [content],
        ),
        if (!isExpanded) _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.black, thickness: 0.1);
  }
}