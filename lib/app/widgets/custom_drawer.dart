
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';
import '../config/app_sized_box.dart';
import '../views/admin/admin_manage_attractions_screen.dart';
import '../views/admin/admin_manage_hotel_screen.dart';
import '../views/admin/admin_manage_users_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/user/user_view_all_attraction_screen.dart';
import '../views/user/user_view_all_hotel_screen.dart';
import 'custom_text.dart';

class CustomDrawer extends StatelessWidget {
  final bool isAdmin;

  const CustomDrawer({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    bool isGuest = currentUser == null;
    bool isAdminUser = currentUser?.email == "admin@gmail.com";

    return SafeArea(
      child: ListTileTheme(
        textColor: AppColors.white,
        iconColor: AppColors.white,
        child: Drawer(
          backgroundColor: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.space25h,

              // Display User Info or Guest Info
              Padding(
                padding: EdgeInsets.all(15.w),
                child: isGuest
                    ? _buildUserInfo("Welcome Guest", "guest@trippygo.com")
                    : StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return _buildUserInfo("Admin", "admin@gmail.com");
                    }
                    Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;

                    return _buildUserInfo(
                      userData['username']?.toString().toUpperCase() ?? "Welcome Guest",
                      userData['email'] ?? "guest@trippygo.com",
                    );
                  },
                ),
              ),

              AppSizedBox.space10h,

              // Display menu options
              isAdminUser ? _buildAdminMenu() : _buildCommonMenu(),

              Spacer(),

              Padding(
                padding: EdgeInsets.only(bottom: 35.h),
                child: ListTile(
                  onTap: () async {
                    if (!isGuest) {
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(LoginScreen());
                    } else {
                      Get.to(LoginScreen());
                    }
                  },
                  leading: Image.asset(
                    currentUser != null
                        ? 'assets/images/logout.png'
                        : 'assets/images/login.png',
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.black,
                  ),
                  title: CustomText(
                    textColor: AppColors.black,
                    fontSize: 14.sp,
                    title: isGuest ? "Login" : "Logout",
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                    textStyle: GoogleFonts.quicksand(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display user info
  Widget _buildUserInfo(String username, String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          firstText: "Trippy",
          secondText: " Go",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 20.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        CustomText(
          textColor: AppColors.black,
          fontSize: 12.h,
          title: "Dashboard",
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          textStyle: GoogleFonts.quicksand(),
        ),
        AppSizedBox.space10h,
        CustomText(
          textColor: AppColors.black,
          fontSize: 16.sp,
          title: username,
          fontWeight: FontWeight.w600,
          textStyle: GoogleFonts.montserrat(),
        ),
        CustomText(
          textColor: AppColors.black,
          fontSize: 13.sp,
          title: email,
          fontWeight: FontWeight.w400,
          textStyle: GoogleFonts.montserrat(),
        ),
      ],
    );
  }

  // Common menu for guest and non-admin users
  Widget _buildCommonMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {},
          trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
          title: CustomText(
            textColor: AppColors.black,
            fontSize: 12.h,
            title: "Home",
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textStyle: GoogleFonts.quicksand(),
          ),
          leading: Image(
            image: AssetImage("assets/images/home.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
        AppSizedBox.space5h,
        ListTile(
          onTap: () {
            Get.to(UserViewAllHotelScreen());
          },
          trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
          title: CustomText(
            textColor: AppColors.black,
            fontSize: 12.h,
            title: "Hotels",
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textStyle: GoogleFonts.quicksand(),
          ),
          leading: Image(
            image: AssetImage("assets/images/hotel.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
        AppSizedBox.space5h,
        ListTile(
          onTap: () {
            Get.to(UserViewAllAttractionScreen());
          },
          trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
          title: CustomText(
            textColor: AppColors.black,
            fontSize: 12.h,
            title: "Attractions",
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textStyle: GoogleFonts.quicksand(),
          ),
          leading: Image(
            image: AssetImage("assets/images/mountain.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
      ],
    );
  }

  // Admin menu options
  Widget _buildAdminMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSizedBox.space15h,
        ListTile(
          onTap: () {
            Get.to(AdminUserlistScreen());
          },
          trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
          title: CustomText(
            textColor: AppColors.black,
            fontSize: 12.h,
            title: "Manage Users",
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textStyle: GoogleFonts.quicksand(),
          ),
          leading: Image(
            image: AssetImage("assets/images/user.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
        AppSizedBox.space5h,
        ListTile(
          onTap: () {
            Get.to(AdminManageHotelScreen());
          },
          trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
          title: CustomText(
            textColor: AppColors.black,
            fontSize: 12.h,
            title: "Manage Hotel",
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textStyle: GoogleFonts.quicksand(),
          ),
          leading: Image(
            image: AssetImage("assets/images/hotel.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
        AppSizedBox.space5h,
        ListTile(
          onTap: () {
            Get.to(AdminManageAttractionScreen());
          },
          trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
          title: CustomText(
            textColor: AppColors.black,
            fontSize: 12.h,
            title: "Manage Attractions",
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textStyle: GoogleFonts.quicksand(),
          ),
          leading: Image(
            image: AssetImage("assets/images/mountain.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
        AppSizedBox.space5h,
        // ListTile(
        //   onTap: () {},
        //   trailing: Icon(Icons.arrow_forward_ios, size: 10.h,color: AppColors.black,),
        //   title: CustomText(
        //     textColor: AppColors.black,
        //     fontSize: 12.h,
        //     title: "Manage Reviews",
        //     maxLines: 2,
        //     textOverflow: TextOverflow.ellipsis,
        //     textAlign: TextAlign.start,
        //     textStyle: GoogleFonts.quicksand(),
        //   ),
        //   leading: Image(
        //     image: AssetImage("assets/images/review.png"),
        //     height: 20.h,
        //     width: 20.w,
        //   ),
        // ),
        // AppSizedBox.space5h,

      ],
    );
  }
}
