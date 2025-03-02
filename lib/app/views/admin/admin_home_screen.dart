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

class AdminHomeScreen extends StatelessWidget {
  final _advancedDrawerController = AdvancedDrawerController();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('mm:ss, EEE d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
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
                    AppSizedBox.space10h,

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
    // Check if the user email matches the admin email
    return user.email == 'admin@gmail.com';
  }

}