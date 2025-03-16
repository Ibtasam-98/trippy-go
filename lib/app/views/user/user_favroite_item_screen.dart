import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippygo/app/config/app_colors.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import 'package:trippygo/app/widgets/custom_text.dart';

class UserFavroiteItemScreen extends StatelessWidget {
  const UserFavroiteItemScreen({super.key});

  // Fetch saved items from shared preferences (both hotels and attractions)
  Future<List<Map<String, dynamic>>> _getSavedItems(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedData = prefs.getStringList(key);

    if (savedData == null) return [];

    return savedData.map((data) => Map<String, dynamic>.from(json.decode(data))).toList();
  }

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
            // Saved Hotels Tab
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getSavedItems('hotel_favorites'), // Fetch saved hotels
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: CustomText(
                      title: "No saved hotels.",
                      fontSize: 16.sp,
                      textColor: AppColors.black,
                    ),
                  );
                }

                List<Map<String, dynamic>> savedHotels = snapshot.data!;
                return ListView.builder(
                  itemCount: savedHotels.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> hotel = savedHotels[index];

                    String hotelName = hotel['name'] ?? 'Unknown Hotel';
                    String hotelDescription = hotel['description'] ?? 'No description available.';
                    String hotelImage = hotel['image'] ?? "assets/images/hotel_placeholder.jpg";
                    String savedTime = hotel['saved_time'] ?? DateTime.now().toString();

                    // Format the saved time
                    DateTime savedDateTime = DateTime.parse(savedTime);
                    String formattedTime = "${savedDateTime.day}/${savedDateTime.month}/${savedDateTime.year} ${savedDateTime.hour}:${savedDateTime.minute}";

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.asset(
                                hotelImage,
                                width: double.infinity,
                                height: 150.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hotel Name
                                  CustomText(
                                    title: hotelName,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: AppColors.black,
                                  ),
                                  SizedBox(height: 5.h),

                                  // Hotel Description
                                  CustomText(
                                    title: hotelDescription,
                                    fontSize: 14.sp,
                                    textColor: AppColors.black.withOpacity(0.7),
                                    maxLines: 2,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10.h),

                                  // Time the hotel was saved
                                  CustomText(
                                    title: "Saved on: $formattedTime",
                                    fontSize: 12.sp,
                                    textColor: AppColors.black.withOpacity(0.5),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            // Saved Attractions Tab (similar to Saved Hotels)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getSavedItems('attraction_favorites'), // Fetch saved attractions
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: CustomText(
                      title: "No saved attractions.",
                      fontSize: 16.sp,
                      textColor: AppColors.black,
                    ),
                  );
                }

                List<Map<String, dynamic>> savedAttractions = snapshot.data!;
                return ListView.builder(
                  itemCount: savedAttractions.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> attraction = savedAttractions[index];

                    String attractionName = attraction['name'] ?? 'Unknown Attraction';
                    String attractionDescription = attraction['description'] ?? 'No description available.';
                    String attractionImage = attraction['image'] ?? "assets/images/attraction.jpg";

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.asset(
                                attractionImage,
                                width: double.infinity,
                                height: 150.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Attraction Name
                                  CustomText(
                                    title: attractionName,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: AppColors.black,
                                  ),
                                  SizedBox(height: 5.h),

                                  // Attraction Description
                                  CustomText(
                                    title: attractionDescription,
                                    fontSize: 14.sp,
                                    textColor: AppColors.black.withOpacity(0.7),
                                    maxLines: 2,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
