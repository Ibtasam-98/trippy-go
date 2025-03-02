
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/views/auth/login_screen.dart';
import 'package:trippygo/app/widgets/custom_text.dart';

import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../controllers/user/welcome_screen_controller.dart';
import '../../widgets/custom_button.dart';
import '../user/user_bottom_navigation.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WelcomeScreenController controller = Get.put(WelcomeScreenController());

    // Check if the user is already logged in
    final User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? user?.email?.split('@')[0] ?? ''; // Get name or email prefix
    final String buttonText = user != null ? "Welcome $userName" : "Continue As Guest";

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            "assets/images/main_bg.png",
            fit: BoxFit.cover,
          ),
        ),

        // Dark Overlay Gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.black,
                  AppColors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),

        Scaffold(
          backgroundColor: AppColors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left:15.w,right: 15.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        title: "Journey",
                        fontSize: 16.sp,
                        isGlass: true,
                        textColor: AppColors.white,
                      ),
                    ),

                    AppSizedBox.space15h,
                    Align(
                      alignment:Alignment.centerLeft,
                      child: CustomText(
                        title: "Expedition",
                        fontSize: 16.sp,
                        isGlass: true,
                        textColor: AppColors.white,
                      ),
                    ),
                    AppSizedBox.space25h,
                    Align(
                      alignment:Alignment.center,
                      child: CustomText(
                        title: "Destinations",
                        fontSize: 16.sp,
                        isGlass: true,
                        textColor: AppColors.white,
                      ),
                    ),
                    AppSizedBox.space30h,
                    Align(
                      alignment:Alignment.centerLeft,
                      child: CustomText(
                        title: "Travel",
                        fontSize: 16.sp,
                        textColor: AppColors.white,
                        isGlass: true,
                      ),
                    ),
                  ],
                ),
              ),
              AppSizedBox.space10h,
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontSize: 30.sp,
                      title: "Explore and discover \nthe world",
                      textColor: AppColors.white,
                      textAlign: TextAlign.start,
                      fontFamily: 'grenda',
                    ),
                    AppSizedBox.space5h,
                    CustomText(
                      fontSize: 16.sp,
                      title: "Browse millions of tourist locations and \nchoose the one that suits you.",
                      textStyle: GoogleFonts.quicksand(),
                      textColor: AppColors.white,
                      textAlign: TextAlign.start,
                      maxLines: 5,
                    ),
                    AppSizedBox.space25h,
                    Obx(() {
                      return AnimatedOpacity(
                        opacity: controller.showGuestButton.value ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: Column(
                          children: [
                            SlideTransition(
                              position: controller.slideAnimation,
                              child: InkWell(
                                hoverColor: AppColors.transparent,
                                highlightColor: AppColors.transparent,
                                splashColor: AppColors.transparent,
                                onTap: () {
                                  Get.to(() => LoginScreen());
                                },
                                child: CustomButton(
                                  height: 45.h,
                                  haveBgColor: true,
                                  btnTitle: "Login", // Dynamic button text
                                  btnTitleColor: AppColors.black,
                                  bgColor: AppColors.white,
                                  borderRadius: 50.r,
                                ),
                              ),
                            ),
                            AppSizedBox.space10h,
                            SlideTransition(
                              position: controller.slideAnimation,
                              child: InkWell(
                                hoverColor: AppColors.transparent,
                                highlightColor: AppColors.transparent,
                                splashColor: AppColors.transparent,
                                onTap: () {
                                 Get.to(() => BottomNavigationDashboard());
                                },
                                child: CustomButton(
                                  height: 45.h,
                                  haveBgColor: false,
                                  btnTitle: "Continue As Guest", // Dynamic button text
                                  btnTitleColor: AppColors.white,
                                  bgColor: AppColors.white,
                                  btnBorderColor: AppColors.white,
                                  borderRadius: 50.r,
                                ),
                              ),
                            ),
                          ],
                        )
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
