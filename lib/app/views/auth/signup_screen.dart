
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/views/auth/login_screen.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../controllers/user/signup_screen_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';


class SignUpScreen extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());

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
                          title: "Registration",
                          fontWeight: FontWeight.w500,
                        ),
                        AppSizedBox.space10h,
                        CustomText(
                          textColor: AppColors.black,
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          maxLines: 5,
                          title: "Welcome! Please enter your details to create an account.",
                        ),
                        AppSizedBox.space25h,
                        Form(
                          key: signUpController.formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                textEditingController: signUpController.userNameController,
                                label: "Username",
                                isPassword: false,
                                borderColor: AppColors.black.withOpacity(0.1),
                                icon: Icons.person,
                                validator: (value) => value!.isEmpty ? "Enter your username" : null,
                              ),
                              CustomTextField(
                                textEditingController: signUpController.contactNumberController,
                                label: "Contact Number",
                                icon: Icons.phone,
                                borderColor: AppColors.black.withOpacity(0.1),
                                isPassword: false,
                                validator: (value) => value!.isEmpty ? "Enter your contact number" : null,
                              ),
                              CustomTextField(
                                textEditingController: signUpController.userSignUpEmailController,
                                label: "Email",
                                icon: Icons.email,
                                borderColor: AppColors.black.withOpacity(0.1),
                                isPassword: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                              ),
                              CustomTextField(
                                textEditingController: signUpController.userSignUpPasswordController,
                                label: "Password",
                                icon: Icons.lock,
                                isPassword: true,
                                borderColor: AppColors.black.withOpacity(0.1),
                                validator: (value) =>
                                value!.length < 6 ? "Password must be at least 6 characters" : null,
                              ),
                              AppSizedBox.space25h,
                              InkWell(
                                splashColor: AppColors.transparent,
                                onTap: () => signUpController.createUserWithEmailAndPassword(context),
                                child: Obx(
                                      () => signUpController.isLoading.value
                                      ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                                      : CustomButton(
                                    haveBgColor: true,
                                    borderRadius: 80,
                                    height: 45.h,
                                    btnTitle: 'Sign Up',
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
                child:  Expanded(
                  child: CustomText(
                    firstText: "Already have an account?",
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
            ),
          ],
        ),
      ),
    );
  }
}
