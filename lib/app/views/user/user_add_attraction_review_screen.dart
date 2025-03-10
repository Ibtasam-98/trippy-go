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

class UserAddAttractionReviewScreen extends StatefulWidget {
  final String attractionId;

  UserAddAttractionReviewScreen({required this.attractionId});

  @override
  _UserAddAttractionReviewScreenState createState() =>
      _UserAddAttractionReviewScreenState();
}

class _UserAddAttractionReviewScreenState extends State<UserAddAttractionReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0;
  bool _isSubmitting = false;
  String attractionName = '';

  @override
  void initState() {
    super.initState();
    _fetchAttractionName();
  }

  Future<void> _fetchAttractionName() async {
    try {
      DocumentSnapshot attractionDoc = await FirebaseFirestore.instance
          .collection('attractions')
          .doc(widget.attractionId)
          .get();

      if (attractionDoc.exists && attractionDoc.data() != null) {
        var attractionData = attractionDoc.data() as Map<String, dynamic>;
        setState(() {
          attractionName = attractionData['attraction_name'] ?? 'Unknown Attraction';
        });
      }
    } catch (e) {
      print("Error fetching attraction name: $e");
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String username = "Anonymous";
      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('username')) {
          username = data['username'] ?? "Anonymous";
        }
      }

      await FirebaseFirestore.instance.collection('attraction_reviews').add({
        'attractionId': widget.attractionId,
        'attractionName': attractionName,
        'userId': user.uid,
        'username': username,
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

      await Future.delayed(Duration(seconds: 2));
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
            CustomTextField(
              label: "Write your review here...",
              isPassword: false,
              maxLines: 5,
              textEditingController: _reviewController,
              focusNode: FocusNode(),
            ),
            AppSizedBox.space20h,
            _isSubmitting
                ? Center(child: CircularProgressIndicator(color: AppColors.primary))
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
