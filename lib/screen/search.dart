import 'package:flutter/material.dart';
import 'package:weather_project/screen/models/weather_data.dart';
import 'package:weather_project/screen/services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const SearchScreen({super.key, required this.onToggleTheme, required this.isDark});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<WeatherData>? _weatherFuture;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: color.withValues(alpha: 0.2)),
                ),
                width: 300,
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    setState(() {
                      _weatherFuture = WeatherService.fetchWeatherData(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: color.withValues(alpha: 0.4)),
                    hintText: "buscar cidade...",
                    hintStyle: TextStyle(color: color.withValues(alpha: 0.4)),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  widget.isDark ? Icons.light_mode : Icons.dark_mode,
                  color: color.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<WeatherData>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    Center(
                      child: () {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Container(
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Cidade não encontrada", style: TextStyle(color: color, fontSize: 14)),
                                Text("Verifique o nome e tente novamente", style: TextStyle(color: color.withValues(alpha: 0.5), fontSize: 12)),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: 160,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        _weatherFuture = WeatherService.fetchWeatherData(_controller.text);
                                      });
                                    },
                                    backgroundColor: color.withValues(alpha: 0.15),
                                    child: Text("Tente Novamente", style: TextStyle(color: color, fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          return Text("Digite a cidade acima", style: TextStyle(color: color.withValues(alpha: 0.4)));
                        }
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                snapshot.data!.cityName,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color.withValues(alpha: 0.7)),
                              ),
                              Image.network(snapshot.data!.iconUrl, width: 64, height: 64),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '${snapshot.data!.temperature.toStringAsFixed(0)}°C',
                                    style: TextStyle(fontSize: 52, fontWeight: FontWeight.w500, color: color),
                                  ),
                                ]),
                              ),
                              Text(
                                snapshot.data!.condition,
                                style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.6)),
                              ),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      }(),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            Icon(Icons.water_drop, color: color.withValues(alpha: 0.4), size: 20),
                            Text(snapshot.hasData ? '${snapshot.data!.humidity}%' : "-", style: TextStyle(color: color.withValues(alpha: 0.4))),
                            Text("Umidade", style: TextStyle(color: color.withValues(alpha: 0.4))),
                          ]),
                          Column(children: [
                            Icon(Icons.air, color: color.withValues(alpha: 0.4), size: 20),
                            Text(snapshot.hasData ? '${snapshot.data!.windSpeed} km/h' : "-", style: TextStyle(color: color.withValues(alpha: 0.4))),
                            Text("Vento", style: TextStyle(color: color.withValues(alpha: 0.4))),
                          ]),
                          Column(children: [
                            Icon(Icons.thermostat, color: color.withValues(alpha: 0.4), size: 20),
                            Text(snapshot.hasData ? '${snapshot.data!.feelsLike}°C' : "-", style: TextStyle(color: color.withValues(alpha: 0.4))),
                            Text("Sensação", style: TextStyle(color: color.withValues(alpha: 0.4))),
                          ]),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}