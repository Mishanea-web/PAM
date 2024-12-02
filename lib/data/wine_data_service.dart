import 'dart:convert';
import 'package:flutter/material.dart';
import '../domain/wine.dart';

class WineDataService {
  Future<List<Wine>> loadWineData() async {
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
    List<Wine> wines = (parsedData['carousel'] as List)
        .map((data) => Wine.fromJson(data))
        .toList();
    return wines;
  }
}
