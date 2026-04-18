import 'package:flutter/material.dart';
import '../../models/models/weather_model.dart';

class WeatherInfoWidget extends StatelessWidget {
  final WeatherModel? weather;

  const WeatherInfoWidget({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text("${weather?.city ?? 0} ", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(" T${weather?.temp ?? 0} C", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text("W/S ${weather?.windSpeed ?? 0}m/s", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text("${weather?.humidity ?? 0}% ", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
