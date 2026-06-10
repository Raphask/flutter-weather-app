class WeatherData  {
  final String cityName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final String condition;
  final String iconUrl;


  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.condition,
    required this.iconUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'].toDouble(),
      feelsLike: json['current']['feelslike_c'].toDouble(),
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_kph'].toDouble(),
      condition: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
    );
  }
}
