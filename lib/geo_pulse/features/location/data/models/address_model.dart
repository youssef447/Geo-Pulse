
import 'package:get/get.dart';

class Address {
  // Static constants for field keys
  static const String fieldCity = 'City';
  static const String fieldCountry = 'Country';
  static const String fieldState = 'State';
  static const String fieldPostalCode = 'Postal_Code';
  static const String fieldCityArabic = 'City_Arabic';
  static const String fieldCountryArabic = 'Country_Arabic';
  static const String fieldStateArabic = 'State_Arabic';

  // Model fields
  String city;
  String cityArabic;
  String country;
  String countryArabic;
  String stateOrProvince;
  String stateOrProvinceArabic;
  String postalCode;

  // Constructor
  Address({
    required this.city,
    required this.cityArabic,
    required this.country,
    required this.countryArabic,
    required this.stateOrProvince,
    required this.stateOrProvinceArabic,
    required this.postalCode,
  });

  // To Map
  Map<String, dynamic> toMap() {
    return {
      fieldCity: city.toLowerCase(),
      fieldCountry: country.toLowerCase(),
      fieldState: stateOrProvince.toLowerCase(),
      fieldPostalCode: postalCode.toLowerCase(),
      fieldCityArabic: cityArabic.toLowerCase(),
      fieldCountryArabic: countryArabic.toLowerCase(),
      fieldStateArabic: stateOrProvinceArabic.toLowerCase(),
    };
  }

  // From Map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      city: map[fieldCity].toString().capitalize ?? '',
      cityArabic: map[fieldCityArabic].toString().capitalize  ?? '',
      country: map[fieldCountry].toString().capitalize?? '',
      countryArabic: map[fieldCountryArabic].toString().capitalize?? '',
      stateOrProvince: map[fieldState].toString().capitalize?? '',
      stateOrProvinceArabic: map[fieldStateArabic].toString().capitalize?? '',
      postalCode: map[fieldPostalCode].toString().capitalize?? '',
    );
  }
}
