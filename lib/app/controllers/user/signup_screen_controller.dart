import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:trippygo/app/views/auth/login_screen.dart';

class SignUpController extends GetxController {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController userSignUpEmailController = TextEditingController();
  final TextEditingController userSignUpPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  void createUserWithEmailAndPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userSignUpEmailController.text,
        password: userSignUpPasswordController.text,
      );
      User? user = userCredential.user;
      if (user == null) {
        return;
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': userNameController.text,
        'contactNumber': contactNumberController.text,
        'email': user.email!,
      });
      Get.to(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      _showSnackBar(context, 'Signup Failed', e.message ?? 'An unknown error occurred.');
    } catch (e) {
      print("Unexpected error: $e");
      _showSnackBar(context, 'Error', 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
  void _showSnackBar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.failure,
        ),
      ),
    );
  }
}
