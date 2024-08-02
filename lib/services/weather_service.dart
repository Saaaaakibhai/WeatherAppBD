import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherappbd/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    if (cityName.isEmpty) {
      throw Exception('City name is empty');
    }
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apikey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Fetch the current location
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isEmpty) {
      throw Exception('Failed to get city name from coordinates');
    }

    // Extract the city name from the first placemark
    String? city = placemarks[0].locality;
    if (city == null || city.isEmpty) {
      throw Exception('Failed to get city name');
    }

    return city;
  }
}
