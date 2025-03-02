import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/admin/admin_manage_attractions_screen.dart';

class AdminAttractionController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final spotNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final cityController = TextEditingController();
  final entryFeeController = TextEditingController();
  final openingHoursController = TextEditingController();

  // Dropdown selections (Using RxString for reactivity)
  final selectedCategory = "".obs;
  final selectedParking = "".obs;
  final selectedPublicTransport = "".obs;
  final selectedWheelchair = "".obs;
  final selectedSeason = "".obs;

  var isLoading = false.obs; // Loading state

  // Function to set data for editing
  void setAttractionData(dynamic attraction) {
    if (attraction != null) {
      spotNameController.text = attraction['spot_name'] ?? "";
      descriptionController.text = attraction['description'] ?? "";
      cityController.text = attraction['city'] ?? "";
      entryFeeController.text = attraction['entry_fee'] ?? "";
      openingHoursController.text = attraction['opening_hours'] ?? "";

      selectedCategory.value = attraction['category'] ?? "";
      selectedParking.value = attraction['parking'] ?? "";
      selectedPublicTransport.value = attraction['public_transport'] ?? "";
      selectedWheelchair.value = attraction['wheelchair_access'] ?? "";
      selectedSeason.value = attraction['best_season'] ?? "";
    }
  }

  // Function to show time picker
  Future<void> selectOpeningHours(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      openingHoursController.text = pickedTime.format(context);
    }
  }

  // Function to validate alphabetic fields
  String? validateAlphabetic(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required.";
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return "$fieldName should contain only alphabets.";
    }
    return null;
  }

  // Function to validate numeric fields
  String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null; // Entry fee is optional
    } else if (!RegExp(r"^\d+$").hasMatch(value)) {
      return "$fieldName should contain only numbers.";
    }
    return null;
  }

  // Function to save or update attraction data
  Future<void> saveOrUpdateAttraction(BuildContext context, dynamic attraction) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory.value.isEmpty ||
        selectedParking.value.isEmpty ||
        selectedPublicTransport.value.isEmpty ||
        selectedWheelchair.value.isEmpty ||
        selectedSeason.value.isEmpty) {
      _showSnackbar(context, "Error", "Please select all dropdown fields!", ContentType.failure);
      return;
    }

    isLoading.value = true;

    try {
      if (attraction == null) {
        // Add new attraction
        await FirebaseFirestore.instance.collection('attractions').add({
          "spot_name": spotNameController.text,
          "category": selectedCategory.value,
          "description": descriptionController.text,
          "city": cityController.text,
          "opening_hours": openingHoursController.text,
          "entry_fee": entryFeeController.text,
          "parking": selectedParking.value,
          "public_transport": selectedPublicTransport.value,
          "wheelchair_access": selectedWheelchair.value,
          "best_season": selectedSeason.value,
          "created_at": Timestamp.now(),
        });

        _showSnackbar(context, "Success", "Attraction added successfully!", ContentType.success);
      } else {
        // Update existing attraction
        await FirebaseFirestore.instance.collection('attractions').doc(attraction.id).update({
          "spot_name": spotNameController.text,
          "category": selectedCategory.value,
          "description": descriptionController.text,
          "city": cityController.text,
          "opening_hours": openingHoursController.text,
          "entry_fee": entryFeeController.text,
          "parking": selectedParking.value,
          "public_transport": selectedPublicTransport.value,
          "wheelchair_access": selectedWheelchair.value,
          "best_season": selectedSeason.value,
          "updated_at": Timestamp.now(),
        });

        _showSnackbar(context, "Success", "Attraction updated successfully!", ContentType.success);
      }

      // Redirect to AdminManageAttractionScreen after submission
      Future.delayed(Duration(seconds: 1), () {
        Get.off(() => AdminManageAttractionScreen());
      });

    } catch (e) {
      _showSnackbar(context, "Error", "Failed to save attraction: $e", ContentType.failure);
    }

    isLoading.value = false;
  }

  // Function to show Awesome Snackbar
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

  @override
  void onClose() {
    // Dispose controllers when screen is closed
    spotNameController.dispose();
    descriptionController.dispose();
    cityController.dispose();
    entryFeeController.dispose();
    openingHoursController.dispose();
    super.onClose();
  }
}
