import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../config/app_sized_box.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class AdminUserlistScreen extends StatefulWidget {
  @override
  _AdminUserlistScreenState createState() => _AdminUserlistScreenState();
}

class _AdminUserlistScreenState extends State<AdminUserlistScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  void _showUserDetailBottomSheet(BuildContext context, String userId, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: "User Details",
                fontSize: 18.sp,
                fontFamily: 'grenda',
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(userData['username'][0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                title: CustomText(
                  title: userData['username'] ?? 'No Name',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.start,
                  capitalize: true,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: userData['email'] ?? 'No Email',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.start,
                    ),
                    CustomText(
                      title: userData['contactNumber'] ?? 'No Number',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              AppSizedBox.space20h,
              InkWell(
                onTap: () {
                  _deleteUser(context, userId);
                },
                child: CustomButton(
                  haveBgColor: true,
                  btnTitle: "Delete",
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.redDark,
                  borderRadius: 45.r,
                  height: 45.h,
                ),
              ),
              AppSizedBox.space35h,
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteUser(BuildContext context, String userId) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).delete();
      Navigator.pop(context);

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'User deleted successfully!',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: 'Error deleting user: $e',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        title: CustomText(
          firstText: "Trippy",
          secondText: " Go",
          firstTextColor: AppColors.primary,
          secondTextColor: AppColors.black,
          fontFamily: 'grenda',
          fontSize: 15.sp,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.west, color: AppColors.black, size: 20.w),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            CustomTextField(
              label: "Search Users",
              isPassword: false,
              textEditingController: _searchController,
              fillColor: Colors.white,
              borderColor: AppColors.black.withOpacity(0.1),
              borderRadius: 8.0,
              hintFontSize: 14.0,
              prefixIconSize: 20.0,
              keyboardType: TextInputType.text,
              icon: Icons.search,
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No users found"));
                  }

                  var filteredUsers = snapshot.data!.docs.where((doc) {
                    var userData = doc.data() as Map<String, dynamic>;
                    String userName = userData['username']?.toLowerCase() ?? "";
                    String userEmail = userData['email']?.toLowerCase() ?? "";
                    return userName.contains(_searchText) || userEmail.contains(_searchText);
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return Center(child: Text("No matching users found"));
                  }
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var doc = filteredUsers[index];
                      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
                      String userId = doc.id;
                      String userName = userData['username'] ?? 'No Name';
                      String userEmail = userData['email'] ?? 'No Email';
                      String initial = userName.isNotEmpty ? userName[0].toUpperCase() : "?";

                      return Column(
                        children: [
                          ExpansionTile(
                            shape: Border.all(color: AppColors.transparent),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              child: Text(initial, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            title: CustomText(
                              title: userName,
                              fontSize: 14.sp,
                              fontFamily: 'grenda',
                              capitalize: true,
                              fontWeight: FontWeight.bold,
                              textColor: AppColors.black,
                              textAlign: TextAlign.start,
                            ),
                            subtitle: CustomText(
                              title: userEmail,
                              capitalize: true,
                              fontSize: 12.sp,
                              textAlign: TextAlign.start,
                            ),
                            trailing: InkWell(
                              highlightColor:AppColors.transparent,
                              splashColor:AppColors.transparent,
                              onTap:(){
                                _showUserDetailBottomSheet(context, userId, userData);
                                },
                              child: Image.asset(
                                "assets/images/add.png", // Change to minus.png when expanded
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                          Divider(thickness: 1, color: AppColors.black.withOpacity(0.1)), // Divider always visible
                        ],
                      );
                    },
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
