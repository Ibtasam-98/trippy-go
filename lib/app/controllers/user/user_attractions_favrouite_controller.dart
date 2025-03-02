import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserAttractionsFavoritesController extends GetxController {
  final box = GetStorage();
  var favoriteHotels = <Map<String, dynamic>>[].obs; // ✅ Observable list

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    List<dynamic>? savedFavorites = box.read<List<dynamic>>('favoriteHotels');

    if (savedFavorites != null) {
      favoriteHotels.assignAll(savedFavorites.map((hotel) {
        var hotelMap = Map<String, dynamic>.from(hotel);

        if (hotelMap.containsKey('created_at') && hotelMap['created_at'] is String) {
          hotelMap['created_at'] = DateTime.parse(hotelMap['created_at']);
        }
        if (hotelMap.containsKey('updated_at') && hotelMap['updated_at'] is String) {
          hotelMap['updated_at'] = DateTime.parse(hotelMap['updated_at']);
        }

        return hotelMap;
      }).toList());
    }
  }


  void toggleFavorite(Map<String, dynamic> hotel) {
    bool isAlreadyFavorite = favoriteHotels.any((h) => h['name'] == hotel['name']);

    if (isAlreadyFavorite) {
      favoriteHotels.removeWhere((h) => h['name'] == hotel['name']); // Remove favorite
    } else {
      // Convert Timestamp fields to String
      Map<String, dynamic> hotelCopy = Map<String, dynamic>.from(hotel);

      if (hotelCopy.containsKey('created_at') && hotelCopy['created_at'] is Timestamp) {
        hotelCopy['created_at'] = (hotelCopy['created_at'] as Timestamp).toDate().toIso8601String();
      }
      if (hotelCopy.containsKey('updated_at') && hotelCopy['updated_at'] is Timestamp) {
        hotelCopy['updated_at'] = (hotelCopy['updated_at'] as Timestamp).toDate().toIso8601String();
      }

      favoriteHotels.add(hotelCopy); // Add modified hotel to favorites
    }

    box.write('favoriteHotels', favoriteHotels.toList()); // ✅ Save to GetStorage
  }


  bool isFavorite(String hotelName) {
    return favoriteHotels.any((hotel) => hotel['name'] == hotelName);
  }
}
