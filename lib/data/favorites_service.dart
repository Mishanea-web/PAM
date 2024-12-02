import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  List<String> _favoriteWines = [];

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoriteWines = prefs.getStringList('favorites') ?? [];
  }

  void toggleFavorite(String wineName) async {
    if (_favoriteWines.contains(wineName)) {
      _favoriteWines.remove(wineName);
    } else {
      _favoriteWines.add(wineName);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoriteWines);
  }

  bool isFavorite(String wineName) {
    return _favoriteWines.contains(wineName);
  }
}
