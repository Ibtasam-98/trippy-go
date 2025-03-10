import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trippygo/app/views/user/user_attraction_detail_screen.dart';
import 'package:trippygo/app/views/user/user_hotel_detail_screen.dart';
import 'package:trippygo/app/views/user/user_view_all_attraction_screen.dart';
import 'package:trippygo/app/views/user/user_view_all_hotel_screen.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../controllers/user/bottom_navigation_controller.dart';
import '../../controllers/user/user_attraction_favrouite_controller.dart';
import '../../controllers/user/user_hotel_favrouite_controller.dart';
import '../../controllers/user/user_home_screen_controller.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class UserHomeScreen extends StatelessWidget {
  final User? user;
  UserHomeScreen({this.user});


  final UserHomeScreenController controller = Get.put(UserHomeScreenController());
  final TextEditingController searchController = TextEditingController(); // FIXED: Defined controller
  final BottomNavigationController bottomNavController = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        return AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.white,
          ),
          controller: controller.advancedDrawerController,
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
          drawer: CustomDrawer(isAdmin: false),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.transparent,
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
              leading: IconButton(
                onPressed: controller.handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: controller.advancedDrawerController,
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
            ),
            body:SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontSize: 20.sp,
                      title: "Discover",
                      fontFamily: 'grenda',
                    ),
                    CustomText(
                      fontSize: 13.sp,
                      title: "Explore the beautiful Destinations",
                      fontFamily: 'quicksand',
                    ),
                    AppSizedBox.space10h,
                    CustomTextField(
                      label: "Search Destination",
                      isPassword: false,
                      textEditingController: searchController,
                      borderColor: AppColors.black.withOpacity(0.1),
                      borderRadius: 10.r,
                      icon: Icons.search,
                      prefixIconSize: 17.h,
                      hintFontSize: 10.h,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    AppSizedBox.space10h,
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                          child: Image.asset(
                            "assets/images/dashboardHeaderBg.png",
                            height: 150.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 150.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.r)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.black.withOpacity(0.4),
                                AppColors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30.h,
                          left: 10.w,
                          right: 20.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: "New Destinations",
                                fontSize: 13.sp,
                                textColor: AppColors.white,
                              ),
                              CustomText(
                                title: "Discover Recreational Spots",
                                fontSize: 20.sp,
                                fontFamily: 'grenda',
                                fontWeight: FontWeight.bold,
                                textColor: AppColors.white,
                              ),
                              Divider(thickness: 1.5, color: AppColors.white),
                              CustomText(
                                title: "Explore more beautiful destinations around the world",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.white,
                                fontFamily: 'quicksand',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.space10h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          fontSize: 16.sp,
                          title: "The most relevant",
                          fontFamily: 'grenda',
                        ),
                        CustomText(
                          fontSize: 14.sp,
                          title: "View All",
                          textColor: AppColors.primary,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    AppSizedBox.space15h,
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildShimmerEffect();  // Show shimmer effect while loading
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: CustomText(
                              title: "No hotels available",
                              fontSize: 16.sp,
                            ),
                          );
                        }

                        var hotels = snapshot.data!.docs;
                        var limitedHotels = hotels.take(3).toList();

                        return SizedBox(
                          height: 210.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: limitedHotels.length,
                            itemBuilder: (context, index) {
                              var hotel = limitedHotels[index];
                              return GestureDetector(
                                onTap: () {
                                  print(hotel.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserHotelDetailScreen(
                                        hotel: hotel.data() as Map<String, dynamic>,
                                        hotelID: hotel.id.toString(),
                                        hotelName: hotel['name'],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Container(
                                    height: 210.h,
                                    width: 250.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(color: AppColors.black.withOpacity(0.1), width: 0.5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.r),
                                            topRight: Radius.circular(15.r),
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                "assets/images/hotel_placeholder.jpg",
                                                width: 250.w,
                                                height: 150.h,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                top: 10.h,
                                                right: 10.w,
                                                child: GestureDetector(
                                                  onTap: () {
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.favorite ,
                                                      color: AppColors.redDark ,
                                                      size: 20.sp,
                                                    ),
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(12.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CustomText(
                                                    title: hotel['name'],
                                                    capitalize: true,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColors.black,
                                                    fontFamily: 'grenda',
                                                    textOverflow: TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      CustomText(
                                                        title: hotel['category'].toString().split('-')[0],
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.normal,
                                                        textColor: AppColors.black,
                                                      ),
                                                      AppSizedBox.space5w,
                                                      Icon(Icons.star, color: AppColors.primary, size: 16),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              CustomText(
                                                fontSize: 12.sp,
                                                title: hotel['name'],
                                                capitalize: true,
                                                maxLines: 2,
                                                textOverflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                          fontSize: 16.sp,
                          title: "Discover new places",
                          fontFamily: 'grenda',
                        ),
                        CustomText(
                          fontSize: 14.sp,
                          title: "View All",
                          textColor: AppColors.primary,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    AppSizedBox.space5h,
                    Container(
                      height: 140.h,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('attractions').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildShimmerEffect();  // Show shimmer effect while loading
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: CustomText(
                                title: "No attractions found!",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.grey,
                              ),
                            );
                          }

                          var attractions = snapshot.data!.docs;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: attractions.length,
                            itemBuilder: (context, index) {
                              var attraction = attractions[index];
                              return AttractionCard(attraction: attraction);
                            },
                          );
                        },
                      ),
                    ),
                    AppSizedBox.space25h,
                  ],
                ),
              ),
            )),
        );
      },
    );
  }
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 150.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Container(
              width: 250.w,
              height: 210.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          );
        },
      ),
    ),
  );
}



class AttractionCard extends StatelessWidget {
  final QueryDocumentSnapshot attraction;

  AttractionCard({required this.attraction});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = attraction.data() as Map<String, dynamic>;
    String spotName = data['attraction_name'] ?? "Unknown";
    String category = data['category'] ?? "Uncategorized";
    String imagePath = category.toLowerCase() == "museum"
        ? "assets/images/museum.png"
        : "assets/images/attraction.jpg";


    return GestureDetector(
      onTap: () {
        Get.to(() => UserAttractionDetailScreen(attraction: attraction));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              image: DecorationImage(
                image: AssetImage(imagePath), // 🖼 Dynamic Image
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    spotName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'quicksand',
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.h),
                        child: Icon(
                           Icons.favorite,
                          color:AppColors.redDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}