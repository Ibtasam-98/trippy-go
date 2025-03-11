import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttractionBookingController extends GetxController {
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController checkInTimeController = TextEditingController();
  final TextEditingController numberOfGuestsController = TextEditingController();
  final RxBool additionalService = false.obs;
  final RxBool isLoading = false.obs;
  final RxString username = ''.obs;
  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId.value = user.uid;

      // Fetch additional user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        username.value = userDoc['username']?.toString() ?? 'Unknown User';
      } else {
        username.value = 'Unknown User';
      }
    }
  }

  void bookAttraction(String attractionName, String attractionID, BuildContext context) async {
    if (!_validateFields()) return;
    isLoading.value = true;

    try {
      await FirebaseFirestore.instance.collection('booking_Attraction').add({
        'userId': userId.value,
        'username': username.value,
        'attractionName': attractionName,
        'attractionID': attractionID,
        'nationality': nationalityController.text.trim(),
        'checkInTime': checkInTimeController.text.trim(),
        'numberOfGuests': numberOfGuestsController.text.trim(),
        'additionalService': additionalService.value,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSnackbar(context, "Success", "Booking confirmed!", ContentType.success);
    } catch (e) {
      _showSnackbar(context, "Booking Failed", e.toString(), ContentType.failure);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void selectCheckInTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      checkInTimeController.text = pickedTime.format(context);
    }
  }

  bool _validateFields() {
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(nationalityController.text)) {
      Get.snackbar("Error", "Invalid nationality");
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(numberOfGuestsController.text)) {
      Get.snackbar("Error", "Number of guests must be digits");
      return false;
    }
    return true;
  }
}
