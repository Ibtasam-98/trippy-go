import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/config/app_sized_box.dart';
import 'package:trippygo/app/controllers/user/user_attractions_favrouite_controller.dart';
import 'package:trippygo/app/views/user/user_hotel_detail_screen.dart';
import 'package:trippygo/app/widgets/custom_text.dart';

import '../../config/app_colors.dart';

class UserFavroiteItemScreen extends StatelessWidget {
  const UserFavroiteItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAttractionsFavoritesController favoritesController = Get.find<UserAttractionsFavoritesController>();

    return Scaffold(
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
      ),
      body: Obx(() {
        if (favoritesController.favoriteHotels.isEmpty) {
          return Center(child: Text("No favorite hotels yet."));
        }

        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: favoritesController.favoriteHotels.length,
          itemBuilder: (context, index) {
            var hotel = favoritesController.favoriteHotels[index];

            return GestureDetector(
              onTap: () {
                Get.to(UserHotelDetailScreen(hotel: hotel,));
              },
              child: Card(
                color: AppColors.white,
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)), // ✅ Apply border radius to all sides
                      child: Image.asset(
                        "assets/images/hotel_placeholder.jpg",
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title:hotel['name'],
                            fontSize: 14.sp,
                            capitalize: true,
                          ),
                          CustomText(
                            title:hotel['city'],
                            fontSize: 10.sp,
                            capitalize: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

