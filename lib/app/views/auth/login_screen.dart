import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippygo/app/views/auth/signup_screen.dart';
import 'package:trippygo/app/widgets/custom_text.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../controllers/user/login_screen_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());

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
            child: Icon(Icons.west, color: AppColors.black, size: 20.w),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Form(
                      key: _formKey,
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
                            title: "Login",
                            fontWeight: FontWeight.w500,
                          ),
                          AppSizedBox.space10h,
                          CustomText(
                            textColor: AppColors.black,
                            fontSize: 14.sp,
                            maxLines: 5,
                            textAlign: TextAlign.start,
                            title: "Welcome Back! Please enter your credentials to login.",
                          ),
                          AppSizedBox.space25h,
                          CustomTextField(
                            label: 'Email',
                            isPassword: false,
                            icon: FontAwesomeIcons.inbox,
                            textEditingController: controller.userEmailController,
                            validator: controller.emailValidator,
                            borderColor: AppColors.black.withOpacity(0.1),
                          ),
                          AppSizedBox.space5h,
                          CustomTextField(
                            label: 'Password',
                            isPassword: true,
                            borderColor: AppColors.black.withOpacity(0.1),
                            icon: Icons.password,
                            textEditingController: controller.userPasswordController,
                            validator: controller.passwordValidator,
                          ),
                          AppSizedBox.space5h,
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              fontSize: 12.sp,
                              title: "Forgot Password?",
                              textColor: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              textStyle: GoogleFonts.montserrat(),
                            ),
                          ),
                          AppSizedBox.space15h,
                          InkWell(
                            splashColor: AppColors.transparent,
                            hoverColor: AppColors.transparent,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                controller.signInWithEmailAndPassword(context, _formKey);
                              }
                            },
                            child: Obx(() => controller.isLoading.value
                                ? Center(child: CircularProgressIndicator(color: AppColors.black))
                                : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: CustomButton(
                                haveBgColor: true,
                                borderRadius: 80,
                                height: 45.h,
                                btnTitle: 'Login',
                                btnTitleColor: AppColors.white,
                                bgColor: AppColors.primary,
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              onTap: (){
                Get.to(SignUpScreen());
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: CustomText(
                  firstText: "Don't have an Account? ",
                  secondText: "Register here",
                  firstTextColor: AppColors.black,
                  secondTextColor: AppColors.primary,
                  fontFamily: 'quicksand',
                  fontSize: 12.sp,
                  mainAxisAlignment: MainAxisAlignment.center,
                  firstTextFontWeight: FontWeight.bold,
                  secondTextFontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}