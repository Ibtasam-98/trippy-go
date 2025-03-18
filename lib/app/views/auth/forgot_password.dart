import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/views/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    isLoading.value = true;
    String email = _emailController.text.trim();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email")),
      );
      Get.off(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') {
        message = "Email does not exist";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }

    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/auth_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.west, color: AppColors.black),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          firstText: "Trippy",
                          secondText: " Go",
                          firstTextColor: AppColors.primary,
                          secondTextColor: AppColors.black,
                          fontFamily: 'grenda',
                          fontSize: 20.sp,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        CustomText(
                          textColor: AppColors.black,
                          fontSize: 16.sp,
                          title: "Forgot Password",
                          fontWeight: FontWeight.w500,
                        ),
                        AppSizedBox.space10h,
                        CustomText(
                          textColor: AppColors.black,
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          maxLines: 5,
                          title: "Enter your registered email to reset your password.",
                        ),
                        AppSizedBox.space25h,
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                textEditingController: _emailController,
                                label: "Email",
                                icon: Icons.email,
                                borderColor: AppColors.black.withOpacity(0.1),
                                isPassword: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                              ),
                              AppSizedBox.space25h,
                              InkWell(
                                splashColor: AppColors.transparent,
                                onTap: _resetPassword,
                                child: Obx(
                                      () => isLoading.value
                                      ? Center(
                                    child: CircularProgressIndicator(color: AppColors.primary),
                                  )
                                      : CustomButton(
                                    haveBgColor: true,
                                    borderRadius: 80,
                                    height: 45.h,
                                    btnTitle: 'Reset Password',
                                    btnTitleColor: AppColors.white,
                                    bgColor: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: InkWell(
                highlightColor: AppColors.transparent,
                splashColor: AppColors.transparent,
                onTap: () => Get.to(LoginScreen()),
                child: CustomText(
                  firstText: "Remembered your password?",
                  secondText: " Login here",
                  firstTextColor: AppColors.black,
                  secondTextColor: AppColors.primary,
                  fontFamily: 'quicksand',
                  fontSize: 12.sp,
                  mainAxisAlignment: MainAxisAlignment.center,
                  firstTextFontWeight: FontWeight.bold,
                  secondTextFontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
