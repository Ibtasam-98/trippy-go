import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trippygo/app/config/app_sized_box.dart';

import '../../config/app_colors.dart';
import '../../widgets/custom_text.dart';
import 'admin_hotel_booking_detail_screen.dart';

class AdminViewAllHotelBookingsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: CustomText(
          firstText: "Hotel",
          secondText: " Booking",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 20.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("bookings_hotels").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return Center(child: CustomText(title: "No Bookings Found", fontSize: 16));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              var data = booking.data() as Map<String, dynamic>;
              String customerName = data["fullName"] ?? "N/A";
              String hotelName = data["hotelName"] ?? "N/A";
              String status = data["bookingStatus"] ?? "N/A";

              String bookingTime = "N/A";
              if (data["timestamp"] != null && data["timestamp"] is Timestamp) {
                DateTime dateTime = (data["timestamp"] as Timestamp).toDate();
                bookingTime = DateFormat("d MMM h:mm a").format(dateTime);
              }

              return GestureDetector(
                onTap: () {
                  Get.to(() => AdminHotelBookingDetailScreen(
                    bookingId: booking.id,
                    bookingType: "hotel",
                    isComingFromAttractionCard: false,
                  ));
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.grey, width: 1),
                    color: AppColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 20.r,
                          child: CustomText(
                            title: customerName[0].toUpperCase(),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                      AppSizedBox.space10h,
                      CustomText(
                        title: customerName,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: "Hotel: $hotelName",
                        fontSize: 14,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: "Booking: $bookingTime",
                        fontSize: 12,
                        textColor: AppColors.black,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: "Status: $status",
                        fontSize: 12,
                        textColor: AppColors.black,
                        capitalize: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
