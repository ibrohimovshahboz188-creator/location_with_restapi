part of 'weather_cubit.dart';

class WeatherState extends Equatable {
  final WeatherModel? centerWeather;
  final String addressName;
  final bool isLoading;

  const WeatherState({
    this.centerWeather,
    this.addressName = '',
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [centerWeather, addressName, isLoading];
}
