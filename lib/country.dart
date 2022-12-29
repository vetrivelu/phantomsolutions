import 'package:phantomsolutions/services/location_controller.dart';

class Country {
  final Map<dynamic, dynamic> countryJson;

  Country(this.countryJson);

  String get name => countryJson["name"]["common"];

  String get flagUrl => countryJson["flags"]["png"];

  String get countryCode => countryJson["cca3"];

  List<dynamic> get latlang => countryJson["latlng"];

  String get key {
    return currencies.fold(name.trim().toLowerCase(), (previousValue, element) => "${previousValue}_${element.code.trim().toLowerCase()}");
  }

  List<Currency> get currencies {
    List<Currency> currencyObjects = [];
    if (countryJson["currencies"] != null) {
      (countryJson["currencies"] as Map).forEach((key, value) {
        currencyObjects.add(Currency(code: key, name: value["name"], symbol: value["symbol"]));
      });
    }
    return currencyObjects;
  }

  Future<void> delete() {
    return LocationController().deleteLocation(key);
  }
}

class Currency {
  final String code;
  final String name;
  final String? symbol;

  Currency({required this.code, required this.name, required this.symbol});
}
