import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:phantomsolutions/country.dart';

const url = "https://restcountries.com/v3.1/all";

class LocationController {
  static final LocationController _instance = LocationController._internal();

  factory LocationController() {
    return _instance;
  }

  Uri get uri => Uri.parse(url);

  List<Country> locations = [];

  LocationController._internal();

  Future<void> initializeHive() async {
    return Hive.initFlutter().then((value) {
      Hive.openBox("Locations");
    });
  }

  Future<void> downloadLocations() async {
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        locations.clear();
        for (var element in jsonResponse) {
          locations.add(Country(element));
        }
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
    return;
  }

  Future<void> storeLocations() async {
    var box = Hive.box("Locations");
    return box.clear().then((value) {
      for (var element in locations) {
        box.put(element.key, element.countryJson);
      }
    });
  }

  List<Country> fetchLocations(String search, int pageNumber) {
    var box = Hive.box("Locations");
    if (search.isEmpty) {
      var countries = box.values.map((e) => Country(e as Map)).toList();
      return countries.take(pageNumber * 15).toList();
    } else {
      List<Country> countries = [];
      var filteredkeys = box.keys.where((element) => element.toString().contains(search.toLowerCase()));
      var uniquekeys = filteredkeys.toSet();
      for (var key in uniquekeys) {
        countries.add(Country(box.get(key)));
      }
      print(uniquekeys);
      print(countries.map((e) => e.key).toList());
      return countries;
    }
  }

  Future<void> deleteLocation(String key) {
    var box = Hive.box("Locations");
    print(key);
    return box.delete(key);
  }
}
