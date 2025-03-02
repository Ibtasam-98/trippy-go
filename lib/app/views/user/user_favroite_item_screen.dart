import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/config/app_colors.dart';
import 'package:trippygo/app/widgets/custom_text.dart';

class UserFavroiteItemScreen extends StatelessWidget {
  const UserFavroiteItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            indicatorColor: AppColors.primary,
            labelPadding: EdgeInsets.all(5.h),
            labelStyle: GoogleFonts.quicksand(),
            unselectedLabelColor: AppColors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.primary,
            dividerColor: AppColors.transparent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Saved Hotels"),
              Tab(text: "Saved Attractions"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: CustomText(
                title: "No saved hotels.",
                fontSize: 16.sp,
                textColor: AppColors.black,
              ),
            ),
            Center(
              child: CustomText(
                title: "No saved attractions.",
                fontSize: 16.sp,
                textColor: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
