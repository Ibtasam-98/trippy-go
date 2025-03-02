
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:trippygo/app/views/user/user_booking_screen.dart';
import 'package:trippygo/app/views/user/user_favroite_item_screen.dart';
import 'package:trippygo/app/views/user/user_home_screen.dart';
import 'package:trippygo/app/views/user/user_reviews_screen.dart';

import '../../config/app_colors.dart';
import '../../controllers/user/bottom_navigation_controller.dart';

class BottomNavigationDashboard extends StatelessWidget {
  BottomNavigationController controller = BottomNavigationController();

  static List<Widget> widgetOptions = <Widget>[
    UserHomeScreen(),
    UserFavroiteItemScreen(),
    UserBookingScreen(),
    UserReviewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(
            () => Center(
          child: widgetOptions.elementAt(controller.currentIndex),
        ),
      ),
      bottomNavigationBar: Obx(
            () {

          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: GNav(
                  gap: 15,
                  activeColor: AppColors.white,  // Active color based on the theme
                  textStyle: GoogleFonts.quicksand(
                    color: AppColors.black,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: AppColors.primary,
                  iconSize: 18.sp,
                  //color: AppColors.black,  // Icon color based on theme
                  tabs: [
                    GButton(
                      icon: Icons.circle, // Placeholder icon (won't be visible)
                      iconColor: Colors.transparent, // Hide the icon
                      leading: Image.asset(
                        'assets/images/home.png', // Replace with your image
                        width: 22.w,
                        height: 22.h,
                      ),
                      text: 'Home',
                    ),


                    GButton(
                      icon: Icons.circle, // Placeholder icon (won't be visible)
                      iconColor: Colors.transparent, // Hide the icon
                      leading: Image.asset(
                        'assets/images/fav.png', // Replace with your image
                        width: 22.w,
                        height: 22.h,
                      ),
                      text: 'Favrouite',
                    ),
                    GButton(
                      icon: Icons.circle, // Placeholder icon (won't be visible)
                      iconColor: Colors.transparent, // Hide the icon
                      leading: Image.asset(
                        'assets/images/booking.png', // Replace with your image
                        width: 22.w,
                        height: 22.h,
                      ),
                      text: 'Booking',
                    ),
                    GButton(
                      icon: Icons.circle, // Placeholder icon (won't be visible)
                      iconColor: Colors.transparent, // Hide the icon
                      leading: Image.asset(
                        'assets/images/star.png', // Replace with your image
                        width: 22.w,
                        height: 22.h,
                      ),
                      text: 'Reviews',
                    ),
                  ],
                  selectedIndex: controller.currentIndex,
                  onTabChange: (index) {
                    if (context.mounted) {
                      controller.updateSelectedIndex(index);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
