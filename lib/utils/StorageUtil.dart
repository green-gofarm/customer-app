import 'dart:convert';

import 'package:customer_app/models/address_model.dart';
import 'package:customer_app/models/tag_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static const String _cityKey = 'cities';
  static const String _hashtagKey = 'hashtags';

  static Future<void> storeCities(List<ProvinceModel> cities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> citiesJson =
        cities.map((city) => json.encode(city.toJson())).toList();
    await prefs.setStringList(_cityKey, citiesJson);
  }

  static Future<List<ProvinceModel>> getCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> citiesJson = prefs.getStringList(_cityKey) ?? [];
    return citiesJson
        .map((cityJson) => ProvinceModel.fromJson(json.decode(cityJson)))
        .toList();
  }

  static Future<void> storeHashtags(List<TagCategoryModel> hashtags) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hashtagsJson =
        hashtags.map((hashtag) => json.encode(hashtag.toJson())).toList();
    await prefs.setStringList(_hashtagKey, hashtagsJson);
  }

  static Future<List<TagCategoryModel>> getHashtags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hashtagsJson = prefs.getStringList(_hashtagKey) ?? [];
    return hashtagsJson
        .map((hashtagJson) =>
            TagCategoryModel.fromJson(json.decode(hashtagJson)))
        .toList();
  }
}
