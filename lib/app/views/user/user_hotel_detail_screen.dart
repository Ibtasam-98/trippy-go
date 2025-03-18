import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trippygo/app/config/app_colors.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/views/user/user_add_hotel_review_screen.dart';
import 'package:trippygo/app/views/user/user_hotel_booking_screen.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final String hotelID, hotelName, imagePath; // Add imagePath here

  UserHotelDetailScreen({
    required this.hotel,
    required this.hotelID,
    required this.hotelName,
    required this.imagePath, // Add imagePath here
  });

  @override
  Widget build(BuildContext context) {
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.r),
                    bottomRight: Radius.circular(25.r),
                  ),
                  child: Image.asset(
                    imagePath, // Use imagePath here
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
                      Navigator.pop(context);
                    },
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
                  _buildExpansionTile(
                    title: "Amenities",
                    content: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: (hotel['amenities'] as Map<String, dynamic>).entries
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
                  _buildExpansionTile(
                    title: "Reviews",
                    content: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('hotel_reviews')
                          .where('hotelId', isEqualTo: hotelID)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                            child: CustomText(
                              title: "No reviews available yet",
                              fontSize: 14.sp,
                              textAlign: TextAlign.start,
                              textColor: AppColors.black.withOpacity(0.7),
                            ),
                          );
                        }
                        var reviews = snapshot.data!.docs.map((doc) {
                          final timestamp = doc['timestamp'];
                          final username = doc['username'];
                          DateTime? reviewTime = timestamp != null && timestamp is Timestamp
                              ? timestamp.toDate()
                              : null;
                          return {
                            'review': doc['review'] as String,
                            'username': username as String?,
                            'timestamp': reviewTime,
                          };
                        }).toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reviews.asMap().entries.map<Widget>((entry) {
                            int index = entry.key;
                            var review = entry.value;
                            String formattedTime = "";
                            if (review['timestamp'] != null) {
                              DateTime reviewTimestamp = review['timestamp'] as DateTime;
                              formattedTime = DateFormat('MMMM d, yyyy \u200Bat h:mm a')
                                  .format(reviewTimestamp);
                            } else {
                              formattedTime = "N/A";
                            }
                            String userInitial = (review['username'] as String?)?.isNotEmpty == true
                                ? (review['username'] as String)[0].toUpperCase()
                                : "U";
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(color: AppColors.black.withOpacity(0.1), width: 0.5),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    child: Text(userInitial, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                  ),
                                  title: CustomText(
                                    title: review['review'].toString(),
                                    fontSize: 14.sp,
                                    capitalize: true,
                                    textAlign: TextAlign.start,
                                    textColor: AppColors.black.withOpacity(0.7),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        title: review['username'].toString(),
                                        fontSize: 12.sp,
                                        capitalize: true,
                                        textColor: AppColors.black.withOpacity(0.5),
                                      ),
                                      AppSizedBox.space5h,
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: CustomText(
                                          title: formattedTime,
                                          fontSize: 12.sp,
                                          textStyle: TextStyle(
                                            fontStyle:FontStyle.italic,
                                          ),
                                          textColor: AppColors.black.withOpacity(0.5),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    expansionNotifier: reviewsExpanded,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(UserAddHotelReviewScreen(hotelId: hotelID));
                  },
                  child: CustomButton(
                    haveBgColor: true,
                    btnTitle: "Add Review",
                    height: 45.h,
                    btnTitleColor: AppColors.white,
                    bgColor: AppColors.blue,
                    borderRadius: 45.r,
                  ),
                ),
              ),
              AppSizedBox.space15w,
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(UserHotelBookingScreen(
                      hotelId: hotelID,
                      hotelName: hotelName,
                    ));
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
                isExpanded ? "assets/images/minus.png" : "assets/images/add.png",
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