import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/views/user/user_attraction_detail_screen.dart';

import '../../config/app_colors.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class UserViewAllAttractionScreen extends StatefulWidget {
  @override
  _UserViewAllAttractionScreenState createState() => _UserViewAllAttractionScreenState();
}

class _UserViewAllAttractionScreenState extends State<UserViewAllAttractionScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";


  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case "museum":
        return "assets/images/museum.png";
      case "beach":
        return "assets/images/attraction.jpg";
      case "park":
        return "assets/images/park.jpg";
      case "mountain":
        return "assets/images/mountain.jpg";
      case "historic":
        return "assets/images/museum.png";
      default:
        return "assets/images/attraction.jpg";
    }
  }

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
          onPressed: () => Get.back(),
          icon: Icon(Icons.west, color: AppColors.black, size: 20.w),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            CustomTextField(
              label: "Search Attraction",
              isPassword: false,
              textEditingController: searchController,
              fillColor: Colors.white,
              borderColor: AppColors.black.withOpacity(0.1),
              borderRadius: 8.0,
              hintFontSize: 14.0,
              prefixIconSize: 20.0,
              keyboardType: TextInputType.text,
              icon: Icons.search,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

            SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('attractions').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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

                  var attractions = snapshot.data!.docs.where((doc) {
                    var name = doc["attraction_name"].toString().toLowerCase();
                    return name.contains(searchQuery);
                  }).toList();

                  return GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: attractions.length,
                    itemBuilder: (context, index) {
                      var attraction = attractions[index];
                      String category = attraction['category'] ?? "Uncategorized";
                      String imagePath = _getCategoryImage(category); // Get category-specific image

                      return GestureDetector(
                        onTap: () {
                          Get.to(UserAttractionDetailScreen(attraction: attraction));
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
                                  image: AssetImage(imagePath), // 🖼 Dynamic category image
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
                                          AppColors.black.withOpacity(0.8),
                                          AppColors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Category (Top Right)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: CustomText(
                                        title: category,
                                        fontSize: 12.sp,
                                        textColor: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        capitalize: true,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: CustomText(
                                      title: attraction['attraction_name'],
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      textColor: AppColors.white,
                                      fontFamily: 'quicksand',
                                      capitalize: true,
                                    ),
                                  ),
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
    );
  }
}
