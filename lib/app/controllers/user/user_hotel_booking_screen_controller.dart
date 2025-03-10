import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';

class UserHotelBookingController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();

  var roomType = ''.obs;
  var mealPreference = ''.obs;
  var airportPickup = false.obs;
  var carRental = false.obs;
  var isLoading = false.obs;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onClose() {
    nationalityController.dispose();
    checkInController.dispose();
    checkOutController.dispose();
    guestsController.dispose();
    super.onClose();
  }

  void selectDate(TextEditingController controller, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void showSnackBar(BuildContext context, String title, String message, ContentType type) {
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

  Future<void> bookHotel(String hotelId, String hotelName) async {
    if (!formKey.currentState!.validate()) return;

    if (user == null) {
      showSnackBar(Get.context!, 'Booking Failed', 'You need to register to book a hotel.', ContentType.failure);
      return;
    }

    isLoading.value = true;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (!userDoc.exists) {
        showSnackBar(Get.context!, 'Booking Failed', 'User not found. Please complete your profile.', ContentType.failure);
        isLoading.value = false;
        return;
      }

      String checkInDate = checkInController.text;
      QuerySnapshot existingBookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: user!.uid)
          .where('checkIn', isEqualTo: checkInDate)
          .get();

      if (existingBookings.docs.isNotEmpty) {
        showSnackBar(Get.context!, 'Booking Not Allowed', 'You can book only once per day.', ContentType.failure);
        isLoading.value = false;
        return;
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String bookingType = hotelId.isNotEmpty ? 'hotel' : 'attraction';

      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user!.uid,
        'fullName': userData['username'] ?? 'N/A',
        'email': userData['email'] ?? user!.email,
        'phone': userData['contactNumber'] ?? 'N/A',
        'nationality': nationalityController.text,
        'checkIn': checkInDate,
        'checkOut': checkOutController.text,
        'guests': int.parse(guestsController.text),
        'roomType': roomType.value,
        'mealPreference': mealPreference.value,
        'airportPickup': airportPickup.value,
        'carRental': carRental.value,
        'hotelId': hotelId,
        'hotelName': hotelName,
        'bookingType': bookingType,
        'bookingStatus': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      showSnackBar(Get.context!, 'Booking Successful', 'Your booking has been submitted for approval.', ContentType.success);
    } catch (e) {
      showSnackBar(Get.context!, 'Error', 'Error: $e', ContentType.failure);
    } finally {
      isLoading.value = false;
    }
  }

  String? validateNationality(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your nationality';
    }
    final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

    if (!regex.hasMatch(value)) {
      return 'Only alphabets are allowed';
    }

    return null;
  }


  String? validateGuests(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the number of guests';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid number of guests';
    }
    return null;
  }
}
