import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/wine.dart';
import '../data/favorites_service.dart';
import '../data/wine_data_service.dart';

class WineSelectionScreen extends StatefulWidget {
  @override
  _WineSelectionScreenState createState() => _WineSelectionScreenState();
}

class _WineSelectionScreenState extends State<WineSelectionScreen> {
  List<Wine> wines = [];
  FavoritesService favoritesService = FavoritesService();
  WineDataService wineDataService = WineDataService();

  @override
  void initState() {
    super.initState();
    loadWineData();
    favoritesService.loadFavorites().then((_) {
      setState(() {});
    });
  }

  void loadWineData() {
    wineDataService.loadWineData().then((loadedWines) {
      setState(() {
        wines = loadedWines;
      });
    });
  }

  void toggleFavorite(String wineName) {
    setState(() {
      favoritesService.toggleFavorite(wineName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wine Selection'),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: wines.length,
          itemBuilder: (context, index) {
            final wine = wines[index];
            final isFavorite = favoritesService.isFavorite(wine.name);

            return Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.orange[100],
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                    child: Image.network(
                      wine.image,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wine.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 6),
                        Text(
                          '${wine.type.toUpperCase()} - ${wine.bottleSize} - \$${wine.priceUsd.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.brown[600],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Critic Score: ${wine.criticScore}/100',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.brown[700],
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            toggleFavorite(wine.name);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            decoration: BoxDecoration(
                              color: isFavorite
                                  ? Colors.redAccent
                                  : Colors.orange[300],
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  isFavorite ? 'Added to Favorites' : 'Add to Favorites',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
