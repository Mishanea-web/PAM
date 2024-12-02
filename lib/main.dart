import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WineSelectionScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.teal[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[700],
        ),
      ),
    );
  }
}

class Wine {
  final String name;
  final String image;
  final int criticScore;
  final String bottleSize;
  final double priceUsd;
  final String type;
  final String country;
  final String city;

  Wine({
    required this.name,
    required this.image,
    required this.criticScore,
    required this.bottleSize,
    required this.priceUsd,
    required this.type,
    required this.country,
    required this.city,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      name: json['name'],
      image: json['image'],
      criticScore: json['critic_score'],
      bottleSize: json['bottle_size'],
      priceUsd: json['price_usd'].toDouble(),
      type: json['type'],
      country: json['from']['country'],
      city: json['from']['city'],
    );
  }
}

class WineSelectionScreen extends StatefulWidget {
  @override
  _WineSelectionScreenState createState() => _WineSelectionScreenState();
}

class _WineSelectionScreenState extends State<WineSelectionScreen> {
  List<Wine> wines = [];
  Map<String, bool> favorites = {};

  @override
  void initState() {
    super.initState();
    loadWineData();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteKeys = prefs.getKeys();
    setState(() {
      for (String key in favoriteKeys) {
        favorites[key] = prefs.getBool(key) ?? false;
      }
    });
  }

  Future<void> toggleFavorite(String wineName) async {
    final prefs = await SharedPreferences.getInstance();
    bool currentFavorite = favorites[wineName] ?? false;
    setState(() {
      favorites[wineName] = !currentFavorite;
    });
    await prefs.setBool(wineName, !currentFavorite);
  }

  void loadWineData() {
    String exampleJsonData = '''
    {
      "carousel": [
         {
          "name": "Chateau Margaux 2015",
          "image": "https://vintus.com/wp-content/uploads/2018/08/3-BOUT1-hd.jpg",
          "critic_score": 97,
          "bottle_size": "750 ml",
          "price_usd": 750,
          "type": "red",
          "from": { "country": "France 🇫🇷", "city": "Bordeaux" }
        },
        {
          "name": "Cloudy Bay Sauvignon Blanc 2020",
          "image": "https://simplyalcohol.com.sg/wp-content/uploads/2021/07/Cloudy-Bay-2022-Sauvignon-Blanc-Beauty-Shot-1-scaled-1.png",
          "critic_score": 92,
          "bottle_size": "750 ml",
          "price_usd": 30,
          "type": "white",
          "from": { "country": "New Zealand 🇳🇿", "city": "Marlborough" }
        },
        {
          "name": "Moet & Chandon Imperial Brut",
          "image": "https://www.luxuryformen.com/media/catalog/product/cache/7f855d93df6faf4f4bb5212befedd5ec/m/o/moet-and-chandon-brut-imperial.jpg",
          "critic_score": 89,
          "bottle_size": "750 ml",
          "price_usd": 50,
          "type": "sparkling",
          "from": { "country": "France 🇫🇷", "city": "Champagne" }
        },
        {
          "name": "Penfolds Grange 2016",
          "image": "https://eluenheng.luenheng.com/wp-content/uploads/2023/03/PEN-2015-Grange-Beauty-Vintage-Update.jpg",
          "critic_score": 98,
          "bottle_size": "750 ml",
          "price_usd": 850,
          "type": "red",
          "from": { "country": "Australia 🇦🇺", "city": "Barossa Valley" }
        },
        {
          "name": "Gavi di Gavi La Scolca 2019",
          "image": "https://www.osteria.ru/upload/resize_cache/webp/iblock/ff8/muos3yjgd0qthbq3uagcmgxhteyeonjc/DSC04306.webp",
          "critic_score": 90,
          "bottle_size": "750 ml",
          "price_usd": 40,
          "type": "white",
          "from": { "country": "Italy 🇮🇹", "city": "Piedmont" }
        }
      ]
    } 
    ''';
    final Map<String, dynamic> parsedData = json.decode(exampleJsonData);
    setState(() {
      wines = (parsedData['carousel'] as List)
          .map((data) => Wine.fromJson(data))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wine Selection'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: wines.length,
          itemBuilder: (context, index) {
            final wine = wines[index];
            final isFavorite = favorites[wine.name] ?? false;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.lightBlue[50],
              shadowColor: Colors.blueGrey[200],
              elevation: 4,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: Image.network(
                      wine.image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          wine.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${wine.type} - ${wine.bottleSize} - \$${wine.priceUsd}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${wine.criticScore}/100',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.teal[800]),
                        ),
                        GestureDetector(
                          onTap: () {
                            toggleFavorite(wine.name);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 8.0),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: isFavorite ? Colors.blue[800] : Colors.teal[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                isFavorite ? '★' : '☆',
                                style: TextStyle(fontSize: 24, color: Colors.white),
                              ),
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
