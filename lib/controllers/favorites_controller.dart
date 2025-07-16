// controllers/favorites_controller.dart

import 'package:affirmation_app/models/favourite_model/favorites_model.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var favorites = <String>[].obs;
  var isInitialized = false.obs;
  late FavoritesModel _model;

  RxInt currentIndex = 0.obs; // Make sure currentIndex is an RxInt

  FavoritesController(String collectionName) {
    _model = FavoritesModel();
    _initialize(collectionName);
  }

  void _initialize(String collectionName) async {
    await _model.initializeFirebase();
    isInitialized.value = true;
    fetchFavorites(collectionName);
  }

  void fetchFavorites(String collectionName) async {
    favorites.value = await _model.fetchFavorites(collectionName);
  }
}
