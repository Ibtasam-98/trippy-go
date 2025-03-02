
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  int get currentIndex => selectedIndex.value;

  set currentIndex(int index) {
    selectedIndex.value = index;
  }

  void updateSelectedIndex(int index) {
    if (index != selectedIndex.value) {
      selectedIndex.value = index;
    }
  }

  void onTabTapped(int index) {
    updateSelectedIndex(index);
  }
}
