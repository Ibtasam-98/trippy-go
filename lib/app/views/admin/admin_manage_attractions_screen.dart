import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';
import 'admin_add_attraction_screen.dart';
import 'admin_attraction_detail_screen.dart';

class AdminManageAttractionScreen extends StatefulWidget {
  @override
  _AdminManageAttractionScreenState createState() => _AdminManageAttractionScreenState();
}

class _AdminManageAttractionScreenState extends State<AdminManageAttractionScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case "museum":
        return ["assets/images/meuseum1.jpeg", "assets/images/meusum2.jpeg"].elementAt(DateTime.now().millisecond % 2);
      case "beach":
        return ["assets/images/adventure1.jpeg", "assets/images/adventure2.jpeg", "assets/images/advencture3.jpeg"].elementAt(DateTime.now().millisecond % 3);
      case "park":
        return ["assets/images/park1.jpeg", "assets/images/park2.jpeg", "assets/images/park3.jpeg", "assets/images/park4.jpeg"].elementAt(DateTime.now().millisecond % 4);
      case "mountain":
        return ["assets/images/adventure1.jpeg", "assets/images/adventure2.jpeg", "assets/images/advencture3.jpeg"].elementAt(DateTime.now().millisecond % 3);
      case "historic":
        return ["assets/images/meuseum1.jpeg", "assets/images/meusum2.jpeg"].elementAt(DateTime.now().millisecond % 2);
      default:
        return ["assets/images/adventure1.jpeg", "assets/images/adventure2.jpeg", "assets/images/advencture3.jpeg"].elementAt(DateTime.now().millisecond % 3);
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
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: attractions.length,
                    itemBuilder: (context, index) {
                      var attraction = attractions[index];
                      String category = attraction['category'] ?? "Uncategorized";
                      String imagePath = _getCategoryImage(category);

                      return GestureDetector(
                        onTap: () {
                          Get.to(AdminAttractionDetailScreen(attraction: attraction, imagePath: imagePath));

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
                                  image: AssetImage(imagePath),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.to(AdminAddAttractionScreen()),
        child: Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}