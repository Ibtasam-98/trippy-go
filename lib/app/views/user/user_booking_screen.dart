import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trippygo/app/config/app_sized_box.dart';

import '../../config/app_colors.dart';
import '../../widgets/custom_text.dart';

class UserBookingScreen extends StatefulWidget {
  @override
  _UserBookingScreenState createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.topLeft,
          child: CustomText(
            firstText: "Trippy",
            secondText: " Go",
            firstTextColor: AppColors.primary,
            secondTextColor: AppColors.black,
            fontFamily: 'grenda',
            fontSize: 20.sp,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelPadding: EdgeInsets.all(5.h),
          labelStyle: GoogleFonts.quicksand(),
          unselectedLabelColor: AppColors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: AppColors.primary,
          dividerColor: AppColors.transparent,
          indicatorWeight: 3,
          tabs: [
            Tab(text: "Hotels"),
            Tab(text: "Attractions"),
          ],
        ),

      ),
      body: TabBarView(

        controller: _tabController,
        children: [
          HotelBookingsTab(),
          AttractionBookingsTab(),
        ],
      ),
    );
  }
}

// Fetch and display hotel bookings
class HotelBookingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('bookings_hotels').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No hotel bookings found."));
        }

        var bookings = snapshot.data!.docs;


        return GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];
            String status = booking['bookingStatus'] ?? "Pending";

            // Convert Timestamp to DateTime
            Timestamp timestamp = booking['timestamp'] ?? Timestamp.now();
            DateTime bookingDateTime = timestamp.toDate();

            // Format DateTime to "8: March at 5:00"
            String formattedDate = DateFormat("d: MMMM 'at' h:mm a").format(bookingDateTime);

            // Determine status color
            Color statusColor = status.toLowerCase() == "pending"
                ? AppColors.primary
                : status.toLowerCase() == "accepted"
                ? Colors.green
                : Colors.red;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: AppColors.black.withOpacity(0.1), width: 0.5),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Hotel Name: ${booking['hotelName']}",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                    ),
                    AppSizedBox.space10h,
                    CustomText(
                      title: "Check In: ${booking['checkIn']}",
                      fontSize: 14.sp,
                      maxLines: 2,
                    ),
                    CustomText(
                      title: "Check Out: ${booking['checkOut']}",
                      fontSize: 14.sp,
                      maxLines: 2,
                    ),
                    CustomText(
                      title: "Booking Time: $formattedDate", // Use formatted timestamp
                      fontSize: 14.sp,
                      maxLines: 2,
                    ),
                    CustomText(
                      title: "Status: $status",
                      fontSize: 14.sp,
                      textColor: statusColor,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        );


      },
    );
  }
}

// Fetch and display attraction bookings
class AttractionBookingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('booking_Attraction').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No attraction bookings found."));
        }

        var bookings = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0, // Adjusted for better layout
          ),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];

            // Convert Timestamp to DateTime
            Timestamp timestamp = booking['timestamp'] ?? Timestamp.now();
            DateTime bookingDateTime = timestamp.toDate();

            // Format DateTime to "8: March at 5:00"
            String formattedDate = DateFormat("d: MMMM 'at' h:mm a").format(bookingDateTime);

            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: AppColors.black.withOpacity(0.1), width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Attraction: ${booking['attractionName']}",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                    ),
                    AppSizedBox.space10h,
                    CustomText(
                      title: "Check-in: ${booking['checkInTime']}",
                      fontSize: 14.sp,
                      maxLines: 2,
                    ),
                    CustomText(
                      title: "Nationality: ${booking['nationality']}",
                      fontSize: 14.sp,
                      maxLines: 2,
                    ),
                    AppSizedBox.space5h,
                    CustomText(
                      title: "Time: $formattedDate",
                      fontSize: 14.sp,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
