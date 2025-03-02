import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/views/admin/admin_add_hotel_screen.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';
import 'admin_hotel_detail_screen.dart';

class AdminManageHotelScreen extends StatefulWidget {
  @override
  _AdminManageHotelScreenState createState() => _AdminManageHotelScreenState();
}

class _AdminManageHotelScreenState extends State<AdminManageHotelScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.west, color: AppColors.black, size: 20.w),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: "Search Hotel",
              isPassword: false,
              textEditingController: searchController,
              fillColor: Colors.white,
              borderColor: AppColors.black.withOpacity(0.1),
              borderRadius: 8.0,
              hintFontSize: 14.0, // Adjust hint size if needed
              prefixIconSize: 20.0, // Adjust icon size if needed
              keyboardType: TextInputType.text,
              icon: Icons.search,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

            AppSizedBox.space10h,
            CustomText(
              title: "Our Hotel",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'grenda',
            ),

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: CustomText(
                        title: "No Hotels Available",
                        fontSize: 14.sp,
                      ),
                    );
                  }

                  var hotels = snapshot.data!.docs;

                  // Filter hotels based on search query
                  var filteredHotels = hotels.where((hotel) {
                    String hotelName = hotel['name'].toString().toLowerCase();
                    return hotelName.contains(searchQuery);
                  }).toList();

                  return GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      var hotel = filteredHotels[index];
                      return GestureDetector(
                        onTap: () {
                           Get.to(AdminHotelDetailScreen(hotel: hotel));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150.w,
                              height: 150.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/hotel_placeholder.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.black.withOpacity(0.8),
                                          AppColors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            title: hotel['category'].toString().split('-')[0],
                                            fontSize: 12.sp,
                                            textColor: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          AppSizedBox.space5w,
                                          Icon(Icons.star, color: Colors.yellow, size: 14),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:10,
                                    left:10,
                                    child: CustomText(
                                      title: hotel['name'],
                                      fontSize: 15.sp,
                                      capitalize: true,
                                      fontWeight: FontWeight.bold,
                                      textColor: AppColors.white,
                                      fontFamily: 'quicksand',
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.to(AddHotelScreen());
        },
        child: Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}