import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = "9ac4331294253137ffa5e10cf72cd1d4";
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<List<WeatherModel>> fetchAllWeather() async {
    final List<Future<http.Response>> futures = viloyatlar.map((city) {
      final url = Uri.parse("$_baseUrl?q=$city&appid=$_apiKey&units=metric");
      return http.get(url);
    }).toList();

    final responses = await Future.wait(futures);
    final List<WeatherModel> weatherList = [];

    for (final response in responses) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weatherList.add(WeatherModel(
          city: data['name'],
          temp: data['main']['temp'].toDouble(),
          condition: data['weather'][0]['main'],
          windSpeed: data['wind']['speed'].toDouble(),
          humidity: data['main']['humidity'],
        ));
      }
    }
    return weatherList;
  }

  Future<WeatherModel?> fetchTashkentOnly() async {
    final url = Uri.parse("$_baseUrl?q=Tashkent&appid=$_apiKey&units=metric");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("$e");
    }
    return null;
  }

  Future<WeatherModel?> fetchWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse("$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Obxavo olishda xatolik $e");
    }
    return null;
  }
}
