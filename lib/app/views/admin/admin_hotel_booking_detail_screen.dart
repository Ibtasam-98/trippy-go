import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import 'package:trippygo/app/widgets/custom_button.dart';
import '../../config/app_colors.dart';
import '../../widgets/custom_text.dart';

class AdminHotelBookingDetailScreen extends StatefulWidget {
  final String bookingId;
  final String bookingType;
  bool isComingFromAttractionCard;

  AdminHotelBookingDetailScreen({
    Key? key,
    required this.bookingId,
    required this.bookingType,
    required this.isComingFromAttractionCard,
  }) : super(key: key);

  @override
  _AdminHotelBookingDetailScreenState createState() => _AdminHotelBookingDetailScreenState();
}

class _AdminHotelBookingDetailScreenState extends State<AdminHotelBookingDetailScreen> {
  late DocumentReference bookingRef;
  Map<String, dynamic>? bookingData;

  @override
  void initState() {
    super.initState();
    bookingRef = FirebaseFirestore.instance
        .collection(widget.bookingType == "hotel" ? "bookings_hotels" : "booking_Attraction")
        .doc(widget.bookingId);
    fetchBookingDetails();
  }

  void fetchBookingDetails() async {
    final snapshot = await bookingRef.get();
    if (snapshot.exists) {
      setState(() {
        bookingData = snapshot.data() as Map<String, dynamic>;
      });
    }
  }

  void updateBookingStatus(String status) async {
    await bookingRef.update({'bookingStatus': status});
    setState(() {
      bookingData?["bookingStatus"] = status;
    });
    Get.snackbar("Success", "Booking status updated to $status", backgroundColor: AppColors.primary, colorText: Colors.white);
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "N/A";
    DateTime dateTime = timestamp.toDate();
    return DateFormat("d MMMM h:mm a").format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: CustomText(
          firstText: "Booking",
          secondText: " Detail",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 20.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
      body: bookingData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: "User Information",
              children: [
                CustomText(title: "Customer Name: ${bookingData?["username"]}", fontSize: 16),
                CustomText(title: "Phone: ${bookingData?["phone"] ?? "N/A"}", fontSize: 16),
                CustomText(title: "Nationality: ${bookingData?["nationality"] ?? "N/A"}", fontSize: 16),
              ],
            ),
            AppSizedBox.space10h,

            // Conditional UI for Hotel or Attraction Booking
            widget.bookingType == "hotel"
                ? _buildCard(
              title: "Hotel Information",
              children: [
                CustomText(title: "Hotel Name: ${bookingData?["hotelName"] ?? "N/A"}", fontSize: 16),
                CustomText(title: "Room Type: ${bookingData?["roomType"] ?? "N/A"}", fontSize: 16),
                CustomText(title: "Check In: ${bookingData?["checkIn"] ?? "N/A"}", fontSize: 16),
                CustomText(title: "Check Out: ${bookingData?["checkOut"] ?? "N/A"}", fontSize: 16),
                CustomText(title: "Number of Guests: ${bookingData?["guests"] ?? "N/A"}", fontSize: 16),
                CustomText(title: "Meal Preference: ${bookingData?["mealPreference"] ?? "N/A"}", fontSize: 16),
              ],
            )
                : _buildCard(
              title: "Attraction Information",
              children: [
                CustomText(title: "Attraction Name: ${bookingData?["attractionName"] ?? ""}", fontSize: 16),
                CustomText(title: "Date: ${formatTimestamp(bookingData?["timestamp"])}", fontSize: 16),
                CustomText(title: "Check In: ${bookingData?["checkInTime"] ?? ""}", fontSize: 16),
                CustomText(title: "Number of Guest: ${bookingData?["numberOfGuests"] ?? ""}", fontSize: 16),
              ],
            ),
            AppSizedBox.space10h,

            widget.isComingFromAttractionCard
                ? SizedBox()
                : _buildCard(
              title: "Booking Status",
              children: [
                CustomText(title: "Status: ${bookingData?["bookingStatus"]}", fontSize: 16, textColor: AppColors.primary),
                SizedBox(height: 20),
                if (bookingData?["bookingStatus"] == "Pending")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            updateBookingStatus("approved");
                          },
                          child: CustomButton(
                            height: 45.h,
                            haveBgColor: true,
                            btnTitle: "Approve",
                            btnTitleColor: AppColors.white,
                            bgColor: AppColors.green,
                            borderRadius: 50.r,
                          ),
                        ),
                      ),
                      AppSizedBox.space10w,
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            updateBookingStatus("decline");
                          },
                          child: CustomButton(
                            height: 45.h,
                            haveBgColor: true,
                            btnTitle: "Decline",
                            btnTitleColor: AppColors.white,
                            bgColor: AppColors.redDark,
                            borderRadius: 50.r,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: Get.width,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(10.r),
       border: Border.all(color: AppColors.grey,width: 1),
     ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(title: title, fontSize: 18, textColor: AppColors.black, fontWeight: FontWeight.w500),
            AppSizedBox.space10h,
            ...children,
          ],
        ),
      ),
    );
  }
}