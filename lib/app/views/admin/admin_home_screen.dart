import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_text.dart';
import '../auth/login_screen.dart';
import 'admin_attraction_booking_detail_screen.dart';
import 'admin_hotel_booking_detail_screen.dart';
import 'admin_view_all_hotel_booking_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final _advancedDrawerController = AdvancedDrawerController();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('mm:ss, EEE d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        final isAdmin = snapshot.hasData ? _isAdmin(snapshot.data!) : false;
        return AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.white,
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: false,
          childDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),

          drawer: CustomDrawer(isAdmin: isAdmin),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              centerTitle: false,
              title: CustomText(
                firstText: "Trippy",
                secondText: " Go",
                firstTextColor: AppColors.primary,
                secondTextColor: AppColors.black,
                fontFamily: 'grenda',
                fontSize: 20.sp,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              leading: IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Image.asset(
                        value.visible
                            ? "assets/images/menu_close.png"
                            : "assets/images/menu_open.png",
                        key: ValueKey<bool>(value.visible),
                        color: AppColors.black,
                        width: 20.w,
                        height: 20.h,
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.logout, color: AppColors.redDark),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => LoginScreen());
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textColor: AppColors.primary,
                      fontSize: 16.sp,
                      title: "Welcome Admin",
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      textStyle: GoogleFonts.montserrat(),
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      fontSize: 14.sp,
                      title: formattedDate,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      textStyle: GoogleFonts.montserrat(),
                      fontWeight: FontWeight.w400,
                    ),
                    AppSizedBox.space15h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          textColor: AppColors.black,
                          fontSize: 16.sp,
                          title: "Hotels Bookings",
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          textStyle: GoogleFonts.montserrat(),
                          fontWeight: FontWeight.w600,
                        ),
                        InkWell(
                          onTap: (){
                            Get.to(AdminViewAllHotelBookingsScreen());
                          },
                          child: CustomText(
                            textColor: AppColors.primary,
                            fontSize: 14.sp,
                            title: "View All",
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textStyle: GoogleFonts.montserrat(),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.space10h,
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection("bookings_hotels").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        var bookings = snapshot.data!.docs;

                        if (bookings.isEmpty) {
                          return Center(child: CustomText(title: "No Bookings Found", fontSize: 16));
                        }

                        return SizedBox(
                          height: 70.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              var booking = bookings[index];
                              var data = booking.data() as Map<String, dynamic>;
                              String customerName = data["fullName"] ?? "N/A";
                              String hotelName = data["hotelName"] ?? "N/A";

                              // Convert Firestore Timestamp to readable string format
                              String bookingTime = "N/A";
                              if (data["timestamp"] != null && data["timestamp"] is Timestamp) {
                                DateTime dateTime = (data["timestamp"] as Timestamp).toDate();
                                bookingTime = DateFormat("d MMM h:mm a").format(dateTime); // Example: 8 Mar 5:00 PM
                              }

                              String firstInitial = customerName.isNotEmpty ? customerName[0].toUpperCase() : "?";

                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => AdminHotelBookingDetailScreen(
                                    bookingId: booking.id,
                                    bookingType: "hotel",
                                      isComingFromAttractionCard:false
                                  ));
                                },
                                child: Container(
                                  width: Get.width - 50,
                                  height: 100.h,
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: AppColors.grey, width: 1),
                                    color: AppColors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      // Circular avatar with first initial
                                      CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        radius: 20.r,
                                        child: CustomText(
                                          title: firstInitial,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Wrapping Column inside Expanded to fix layout issue
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              title: customerName,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              capitalize: true,
                                            ),
                                            SizedBox(height: 4),
                                            CustomText(title: "Hotel: $hotelName", fontSize: 14),
                                            CustomText(title: "Booking: $bookingTime", fontSize: 12, textColor: AppColors.black),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, color: AppColors.black, size: 18),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    AppSizedBox.space10h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          textColor: AppColors.black,
                          fontSize: 16.sp,
                          title: "Attractions Bookings",
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          textStyle: GoogleFonts.montserrat(),
                          fontWeight: FontWeight.w600,
                        ),
                        InkWell(
                          onTap: (){
                            Get.to(AttractionBookingsScreen());
                          },
                          child: CustomText(
                            textColor: AppColors.primary,
                            fontSize: 14.sp,
                            title: "View All",
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textStyle: GoogleFonts.montserrat(),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.space10h,
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection("booking_Attraction").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        var bookings = snapshot.data!.docs;

                        if (bookings.isEmpty) {
                          return Center(child: CustomText(title: "No Attraction Found", fontSize: 16));
                        }

                        return SizedBox(
                          height: 70.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              var booking = bookings[index];
                              var data = booking.data() as Map<String, dynamic>;
                              String userName = data["username"] ?? "N/A";
                              String attractionName = data["attractionName"] ?? "N/A";

                              String bookingTime = "N/A";
                              if (data["timestamp"] != null && data["timestamp"] is Timestamp) {
                                DateTime dateTime = (data["timestamp"] as Timestamp).toDate();
                                bookingTime = DateFormat("d MMM h:mm a").format(dateTime); // Example: 8 Mar 5:00 PM
                              }

                              String firstInitial = userName.isNotEmpty ? userName[0].toUpperCase() : "?";

                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => AdminHotelBookingDetailScreen(
                                    bookingId: booking.id,
                                    bookingType: "Attraction",
                                      isComingFromAttractionCard:true
                                  ));
                                  print(booking.id);
                                },
                                child: Container(
                                  width: Get.width - 50,
                                  height: 100.h,
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: AppColors.grey, width: 1),
                                    color: AppColors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      // Circular avatar with first initial
                                      CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        radius: 20.r,
                                        child: CustomText(
                                          title: firstInitial,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Wrapping Column inside Expanded to fix layout issue
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              title: userName,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              capitalize: true,
                                            ),
                                            SizedBox(height: 4),
                                            CustomText(title: "Attraction: $attractionName", fontSize: 14),
                                            CustomText(title: "Booking: $bookingTime", fontSize: 12, textColor: AppColors.black),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, color: AppColors.black, size: 18),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  bool _isAdmin(User user) {
    return user.email == 'admin@gmail.com';
  }
}
