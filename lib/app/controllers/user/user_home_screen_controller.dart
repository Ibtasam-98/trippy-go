import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';

class UserHomeScreenController extends GetxController {
  final AdvancedDrawerController advancedDrawerController = AdvancedDrawerController();

  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }
}