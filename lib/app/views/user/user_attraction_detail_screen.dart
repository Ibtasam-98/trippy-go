import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trippygo/app/views/user/user_add_attraction_review_screen.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class UserAttractionDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot attraction;

  UserAttractionDetailScreen({required this.attraction});

  @override
  _UserAttractionDetailScreenState createState() =>
      _UserAttractionDetailScreenState();
}

class _UserAttractionDetailScreenState extends State<UserAttractionDetailScreen> {
  String? expandedTile;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        (widget.attraction.data() as Map<String, dynamic>) ?? {};

    // Retrieve data from Firestore
    String parking = data['parking'] ?? "Not available";
    String wheelchairAccess = data['wheelchair_access'] ?? "Not available";
    String publicTransport = data['public_transport'] ?? "Not available";
    String bestSeason = data['best_season'] ?? "Not available";

    Map<String, String> amenities = {
      "Parking": parking,
      "Wheelchair Access": wheelchairAccess,
      "Public Transport": publicTransport,
      "Best Season": bestSeason,
    };

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Attraction Image with Rounded Corners
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: Image(
                    image: AssetImage("assets/images/attraction.jpg"),
                    fit: BoxFit.cover,
                    height: 200.h,
                    width: double.infinity,
                  ),
                ),

                // Back Button
                Positioned(
                  top: 40.h,
                  left: 15.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.west,
                      color: AppColors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attraction Name & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          title: data['attraction_name'] ?? "Unknown",
                          fontFamily: 'grenda',
                          fontWeight: FontWeight.bold,
                          textColor: AppColors.black,
                          textAlign: TextAlign.start,
                          capitalize: true,
                          fontSize: 20.sp,
                        ),
                      ),
                      Row(
                        children: [
                          CustomText(
                            title: data['category'] ?? "Uncategorized",
                            fontSize: 18.sp,
                            textColor: AppColors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'grenda',
                          ),
                          AppSizedBox.space5w,
                          Icon(Icons.star, color: AppColors.primary, size: 17.h),
                        ],
                      ),
                    ],
                  ),
                  Divider(thickness: 0.1, color: AppColors.black),

                  // Amenities Section
                  _buildExpansionTile(
                    title: "Amenities",
                    content: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: amenities.entries.map((entry) {
                        return Chip(
                          label: CustomText(
                            title: "${entry.key}: ${entry.value}",
                            fontSize: 12.sp,
                            textColor: AppColors.black,
                            textAlign: TextAlign.start,
                          ),
                          backgroundColor: AppColors.white,
                        );
                      }).toList(),
                    ),
                  ),

                  // Description Section
                  _buildExpansionTile(
                    title: "Description",
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          title: data['description'] ?? "No description available",
                          fontSize: 14.sp,
                          capitalize: true,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black.withOpacity(0.7),
                          maxLines: 20,
                        ),
                      ),
                    ),
                  ),

                  _buildExpansionTile(
                    title: "Reviews",
                    content: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('attraction_reviews')
                          .where('attractionId', isEqualTo: widget.attraction.id)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                            child: CustomText(
                              title: "No reviews available yet",
                              fontSize: 14.sp,
                              textAlign: TextAlign.start,
                              textColor: AppColors.black.withOpacity(0.7),
                            ),
                          );
                        }

                        var reviews = snapshot.data!.docs.map((doc) {
                          final timestamp = doc['timestamp'];
                          final username = doc['username'];

                          DateTime? reviewTime = timestamp != null && timestamp is Timestamp
                              ? timestamp.toDate()
                              : null;

                          return {
                            'review': doc['review'] as String,
                            'username': username as String?,
                            'timestamp': reviewTime,
                            'rating': doc['rating'] ?? 0,
                          };
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reviews.map<Widget>((review) {
                            String formattedTime = review['timestamp'] != null
                                ? DateFormat('MMMM d, yyyy \u200Bat h:mm a').format(review['timestamp'] as DateTime)
                                : "N/A";

                            String userInitial = (review['username'] as String?)?.isNotEmpty == true
                                ? (review['username'] as String)[0].toUpperCase()
                                : "U";

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(color: AppColors.black.withOpacity(0.1), width: 0.5),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    child: Text(userInitial, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        title: review['username'].toString(),
                                        fontSize: 14.sp,
                                        capitalize: true,
                                        textAlign: TextAlign.start,
                                        textColor: AppColors.black.withOpacity(0.7),
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                              (index) => Icon(
                                            index < review['rating']
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: AppColors.primary,
                                            size: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppSizedBox.space5h,
                                      CustomText(
                                        title: review['review'].toString(),
                                        fontSize: 12.sp,
                                        capitalize: true,
                                        textColor: AppColors.black.withOpacity(0.5),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: CustomText(
                                          title: formattedTime,
                                          fontSize: 12.sp,
                                          textStyle: TextStyle(fontStyle: FontStyle.italic),
                                          textColor: AppColors.black.withOpacity(0.5),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                  ),


                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(UserAddAttractionReviewScreen(
                      attractionId: widget.attraction.id,
                    ));
                    print(widget.attraction.id);
                  },
                  child: CustomButton(
                    haveBgColor: true,
                    btnTitle: "Add Review",
                    height: 45.h,
                    btnTitleColor: AppColors.white,
                    bgColor: AppColors.blue,
                    borderRadius: 45.r,
                  ),
                ),
              ),
              AppSizedBox.space15w,
              Expanded(
                child: InkWell(
                  onTap: () {

                  },
                  child: CustomButton(
                    haveBgColor: true,
                    btnTitle: "Add Booking",
                    height: 45.h,
                    btnTitleColor: AppColors.white,
                    bgColor: AppColors.primary,
                    borderRadius: 45.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ExpansionTile builder
  Widget _buildExpansionTile({required String title, required Widget content}) {
    bool isExpanded = expandedTile == title;

    return Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          shape: Border.all(color: AppColors.transparent),
          title: CustomText(
            title: title,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            fontWeight: FontWeight.bold,
            textColor: AppColors.black,
            textAlign: TextAlign.start,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              expandedTile = expanded ? title : null;
            });
          },
          children: [content],
        ),
        if (!isExpanded) Divider(color: AppColors.black, thickness: 0.1),
      ],
    );
  }
}
