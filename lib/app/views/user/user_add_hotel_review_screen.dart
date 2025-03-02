import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/views/user/user_home_screen.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class UserAddHotelReviewScreen extends StatefulWidget {
  final String hotelId;

  UserAddHotelReviewScreen({required this.hotelId});

  @override
  _UserAddHotelReviewScreenState createState() =>
      _UserAddHotelReviewScreenState();
}

class _UserAddHotelReviewScreenState extends State<UserAddHotelReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0;
  bool _isSubmitting = false; // Track submission state
  String hotelName = '';

  @override
  void initState() {
    super.initState();
    _fetchHotelName();
  }

  // Function to fetch hotel name from Firestore
  Future<void> _fetchHotelName() async {
    try {
      DocumentSnapshot hotelDoc = await FirebaseFirestore.instance
          .collection('hotels') // Assuming hotels are stored here
          .doc(widget.hotelId)
          .get();

      if (hotelDoc.exists && hotelDoc.data() != null) {
        var hotelData = hotelDoc.data() as Map<String, dynamic>;
        setState(() {
          hotelName = hotelData['name'] ?? 'Unknown Hotel'; // Set hotel name
        });
      }
    } catch (e) {
      print("Error fetching hotel name: $e");
    }
  }

  void _submitReview() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'You need to register to add a review.',
            contentType: ContentType.failure,
          ),
        ),
      );

      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    String reviewText = _reviewController.text.trim();
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'Review text cannot be empty.',
            contentType: ContentType.failure,
          ),
        ),
      );

      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      // Fetch the username from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Debugging: Print the fetched document data
      print("User Document Data: ${userDoc.data()}");

      // Fetch the username, ensure it exists in Firestore
      String username = "Anonymous";
      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('username')) {
          username = data['username'] ?? "Anonymous";
        } else {
          print("Warning: 'username' field not found in Firestore document.");
        }
      }

      await FirebaseFirestore.instance.collection('hotel_reviews').add({
        'hotelId': widget.hotelId,
        'hotelName': hotelName, // Save the hotel name
        'userId': user.uid,
        'username': username, // Store username
        'review': reviewText,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Review submitted successfully!',
            contentType: ContentType.success,
          ),
        ),
      );

      // Wait for snackbar to show
      await Future.delayed(Duration(seconds: 2));

      // Navigate to home screen
      Get.offAll(UserHomeScreen());
    } catch (e) {
      print("Error submitting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'Failed to submit review: ${e.toString()}',
            contentType: ContentType.failure,
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: CustomText(
          firstText: "Trippy",
          secondText: " Go",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 15.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: "Give Star",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'grenda',
            ),
            AppSizedBox.space10h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                CustomText(
                  title: _rating.toStringAsFixed(1),
                  fontSize: 15.sp,
                ),
              ],
            ),
            AppSizedBox.space10h,
            CustomText(
              title: "Write Review",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'grenda',
            ),
            AppSizedBox.space20h,
            CustomTextField(
              label: "Write your review here...",
              isPassword: false,
              maxLines: 5,
              textEditingController: _reviewController,
              focusNode: FocusNode(),
            ),
            AppSizedBox.space20h,
            _isSubmitting
                ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
                : InkWell(
              onTap: _submitReview,
              child: CustomButton(
                haveBgColor: true,
                height: 45.h,
                btnTitle: "Submit Review",
                btnTitleColor: Colors.white,
                bgColor: AppColors.primary,
                borderRadius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
