

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreenController extends GetxController with SingleGetTickerProviderMixin {
  final PageController pageController = PageController();

  var currentPage = 0.obs;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  var showGuestButton = false.obs;

  var isLoading = false.obs;
  var loadingMessage = "Setting up, please wait a minute".obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(seconds: 3), () {
      showGuestButton.value = true;
      animationController.forward();
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
