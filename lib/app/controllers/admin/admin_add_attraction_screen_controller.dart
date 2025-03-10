import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/admin/admin_manage_attractions_screen.dart';

class AdminAttractionController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final attractionNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final cityController = TextEditingController();
  final entryFeeController = TextEditingController();
  final openingHoursController = TextEditingController();

  final selectedCategory = "".obs;
  final selectedParking = "".obs;
  final selectedPublicTransport = "".obs;
  final selectedWheelchair = "".obs;
  final selectedSeason = "".obs;

  var isLoading = false.obs;

  void setAttractionData(dynamic attraction) {
    if (attraction != null) {
      attractionNameController.text = attraction['attraction_name'] ?? "";
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

  Future<void> selectOpeningHours(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      openingHoursController.text = pickedTime.format(context);
    }
  }

  String? validateAlphabetic(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required.";
    } else if (!RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$").hasMatch(value)) {
      return "$fieldName should contain only letters, spaces, hyphens, or apostrophes.";
    }
    return null;
  }

  String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (!RegExp(r"^\d+(\.\d+)?$").hasMatch(value)) {
      return "$fieldName should contain only numbers.";
    }
    return null;
  }


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
        DocumentReference docRef = await FirebaseFirestore.instance.collection('attractions').add({
          "attraction_name": attractionNameController.text,
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

        await docRef.update({"id": docRef.id});

        _showSnackbar(context, "Success", "Attraction added successfully!", ContentType.success);
      } else {
        await FirebaseFirestore.instance.collection('attractions').doc(attraction.id).update({
          "attraction_name": attractionNameController.text,
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

      Future.delayed(Duration(seconds: 1), () {
        Get.off(() => AdminManageAttractionScreen());
      });

    } catch (e) {
      _showSnackbar(context, "Error", "Failed to save attraction: $e", ContentType.failure);
    }

    isLoading.value = false;
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

  @override
  void onClose() {
    attractionNameController.dispose();
    descriptionController.dispose();
    cityController.dispose();
    entryFeeController.dispose();
    openingHoursController.dispose();
    super.onClose();
  }
}
