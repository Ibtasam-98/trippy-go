
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../views/admin/admin_manage_hotel_screen.dart';

class AdminAddHotelScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  RxString selectedCategory = '3-Star'.obs;
  RxString selectedRoomType = 'Single'.obs;
  RxString selectedBedOption = 'King'.obs;
  RxBool isLoading = false.obs;

  RxMap<String, bool> amenities = <String, bool>{
    "Free Wi-Fi": false,
    "Parking": false,
    "Swimming Pool": false,
    "Gym/Fitness Center": false,
    "Spa & Wellness": false,
    "Restaurant": false,
    "Conference Rooms": false,
    "Room Service": false,
    "Pet-Friendly": false,
  }.obs;

  /// Initializes hotel details if editing an existing one
  void initializeHotel(QueryDocumentSnapshot? hotel) {
    if (hotel == null) return;

    try {
      var hotelData = hotel.data() as Map<String, dynamic>;

      nameController.text = hotelData['name'] ?? '';
      cityController.text = hotelData['city'] ?? '';
      addressController.text = hotelData['address'] ?? '';
      descriptionController.text = hotelData['description'] ?? '';
      contactController.text = hotelData['contact'] ?? '';
      priceController.text = hotelData['price_per_night']?.toString() ?? '0.0';

      selectedCategory.value = hotelData['category'] ?? '3-Star';
      selectedRoomType.value = hotelData['room_type'] ?? 'Single';
      selectedBedOption.value = hotelData['bed_option'] ?? 'King';

      if (hotelData['amenities'] != null) {
        Map<String, dynamic> storedAmenities = hotelData['amenities'];
        amenities.forEach((key, value) {
          amenities[key] = storedAmenities[key] ?? false;
        });
      }
    } catch (e) {
      print("Error initializing hotel data: $e");
    }
  }

  /// Submits or updates a hotel record
  Future<void> submitHotel(QueryDocumentSnapshot? hotel) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      print("Form validation failed.");
      return;
    }

    isLoading.value = true;

    try {
      double price = double.tryParse(priceController.text.trim()) ?? 0.0;
      Map<String, dynamic> hotelData = {
        'name': nameController.text.trim(),
        'city': cityController.text.trim(),
        'category': selectedCategory.value,
        'address': addressController.text.trim(),
        'description': descriptionController.text.trim(),
        'contact': contactController.text.trim(),
        'room_type': selectedRoomType.value,
        'bed_option': selectedBedOption.value,
        'price_per_night': price,
        'amenities': amenities,
        'updated_at': Timestamp.now(),
      };

      if (hotel == null) {
        hotelData['created_at'] = Timestamp.now();
        await FirebaseFirestore.instance.collection('hotels').add(hotelData);
      } else {
        await FirebaseFirestore.instance.collection('hotels').doc(hotel.id).update(hotelData);
      }

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: hotel == null ? 'Hotel added successfully!' : 'Hotel updated successfully!',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(Get.context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      Get.offAll(() => AdminManageHotelScreen());
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: 'Failed to save hotel: $e',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(Get.context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      isLoading.value = false;
    }
  }
}
