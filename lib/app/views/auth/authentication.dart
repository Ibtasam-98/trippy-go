import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trippygo/app/views/auth/welcome_screen.dart';
import '../admin/admin_home_screen.dart';
import '../user/user_bottom_navigation.dart';
import '../user/user_home_screen.dart';

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // User is logged in, redirect to the correct screen
            return _redirectToDashboard(snapshot.data!);
          } else {
            // No user logged in, show WelcomeScreen
            return WelcomeScreen();
          }
        },
      ),
    );
  }

  Widget _redirectToDashboard(User user) {
    print('User email: ${user.email}');
    return (user.email == 'admin@gmail.com')
        ? AdminHomeScreen()
        : BottomNavigationDashboard();
  }
}
