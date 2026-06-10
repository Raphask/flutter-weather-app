import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_project/screen/models/weather_data.dart';

class WeatherService {
  static const String _apiKey = '2a1691c4e1fb42ce985204351261006';

  static String normalizeCity(String city) {
    const withAccents    = 'àáâãäåèéêëìíîïòóôõöùúûüçñÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÇÑ';
    const withoutAccents = 'aaaaaaeeeeiiiiooooouuuucnAAAAAAEEEEIIIIOOOOOUUUUCN';

    String result = city;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return result;
  }

  static Future<WeatherData> fetchWeatherData(String? cityName) async {
    final encodedCity = normalizeCity(cityName!);
    final response = await http.get(
      Uri.parse('https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$encodedCity&lang=pt'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}