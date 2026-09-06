import 'package:flutter/foundation.dart';

class SavedAuctionsService extends ChangeNotifier {
  static final SavedAuctionsService instance = SavedAuctionsService._internal();
  SavedAuctionsService._internal();

  final Set<String> _favoriteIds = {'auc-1', 'auc-5'};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void setFavorite(String id, bool isFav) {
    if (isFav) {
      _favoriteIds.add(id);
    } else {
      _favoriteIds.remove(id);
    }
    notifyListeners();
  }
}
