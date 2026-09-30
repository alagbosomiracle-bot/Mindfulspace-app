import 'dart:math';
import 'package:flutter/material.dart';

import '../data/affirmations.dart';
import '../services/affirmation_service.dart';

class AffirmationController extends ChangeNotifier {
  final Random _random = Random();
  final AffirmationService _service = AffirmationService();

  String currentAffirmation = affirmations.first;

  List<String> favorites = [];

  bool isLoading = true;

  AffirmationController() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      favorites = await _service.getFavorites();
    } catch (e) {
      debugPrint("Favorites loading error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void nextAffirmation() {
    currentAffirmation =
        affirmations[_random.nextInt(affirmations.length)];

    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    try {
      if (favorites.contains(currentAffirmation)) {
        await _service.removeFavorite(currentAffirmation);
        favorites.remove(currentAffirmation);
      } else {
        await _service.addFavorite(currentAffirmation);
        favorites.add(currentAffirmation);
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Favorite error: $e");
    }
  }

  bool get isFavorite =>
      favorites.contains(currentAffirmation);
}