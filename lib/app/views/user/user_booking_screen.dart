import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/config/app_sized_box.dart';

import '../../config/app_colors.dart';
import '../../widgets/custom_text.dart';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          _buildBookingsList("hotel"),
          _buildBookingsList("attraction"),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String bookingType) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("User not logged in"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          .where('bookingType', isEqualTo: bookingType)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No bookings found"));
        }

        var bookings = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
          ),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailScreen(booking: booking),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: AppColors.black.withOpacity(0.1), width: 0.5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          title:booking['hotelName'] ?? "Attraction",
                        fontSize: 18.sp,
                        capitalize: true,
                        fontWeight: FontWeight.w600,
                         ),
                      AppSizedBox.space5w,

                      CustomText(
                        title: 'Check-in: ${booking['checkIn']}',
                        fontSize: 14.sp,
                        capitalize: true,
                      ),
                      CustomText(
                        title: 'Check-Out: ${booking['checkOut']}',
                        fontSize: 14.sp,
                        capitalize: true,
                      ),
                      CustomText(
                        title:'Guests: ${booking['guests']}',
                        fontSize: 14.sp,
                        capitalize: true,
                      ),
                      AppSizedBox.space10h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title:'Booking Status',
                            fontSize: 14.sp,
                            capitalize: true,
                          ),
                          CustomText(
                            title:booking['bookingStatus'],
                            fontSize: 14.sp,
                            capitalize: true,
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}

class BookingDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot booking;
  BookingDetailScreen({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hotel/Attraction: ${booking['hotelName'] ?? "N/A"}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Check-in: ${booking['checkIn']}", style: TextStyle(fontSize: 16)),
            Text("Check-out: ${booking['checkOut']}", style: TextStyle(fontSize: 16)),
            Text("Guests: ${booking['guests']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Booking Status: ${booking['bookingStatus']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}
