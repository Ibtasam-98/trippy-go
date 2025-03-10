import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../views/admin/admin_home_screen.dart';
import '../../views/user/user_bottom_navigation.dart';

class LoginController extends GetxController {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  var isLoading = false.obs;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void signInWithEmailAndPassword(BuildContext context, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmailController.text.trim(),
        password: userPasswordController.text.trim(),
      );
      isLoading.value = false;

      User? user = userCredential.user;
      if (user != null) {
        print('Login successful for ${user.email}');
        if (user.email == "admin@gmail.com") {
          print('Redirecting to Admin Dashboard');
          Get.offAll(() => AdminHomeScreen());
        } else {
          print('Redirecting to User Home');
          Get.offAll(() => BottomNavigationDashboard());
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      print('Login Error: ${e.message}');
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Login Failed',
          message: e.message ?? 'An unknown error occurred. Try again.',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

}
