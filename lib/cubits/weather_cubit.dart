import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import '../models/models/weather_model.dart';
import '../models/services/weather_services.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService = WeatherService();

  WeatherCubit() : super(const WeatherState());

  Future<void> fetchCenterWeather(double lat, double lon) async {
    emit(WeatherState(
      centerWeather: state.centerWeather,
      addressName: state.addressName,
      isLoading: true,
    ));

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      final String address = placemarks.isNotEmpty
          ? placemarks.first.subAdministrativeArea ?? placemarks.first.locality ?? "Nomalum"
          : "Nomalum";

      final weather = await _weatherService.fetchWeatherByCoords(lat, lon);

      emit(WeatherState(
        centerWeather: weather,
        addressName: address,
        isLoading: false,
      ));
    } catch (e) {
      emit(WeatherState(
        centerWeather: state.centerWeather,
        addressName: state.addressName,
        isLoading: false,
      ));
    }
  }
}