import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location_with_restapi/cubits/weather_cubit.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/models/weather_model.dart';
import '../../models/services/weather_services.dart';
import '../widgets/weather_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YandexMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Yandex Map"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                YandexMap(
                  onCameraPositionChanged: (cameraPosition, reason, finish) {
                    if (finish) {
                      context.read<WeatherCubit>().fetchCenterWeather(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                      );
                    }
                  },
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onUserLocationAdded: (view) async {
                    return view.copyWith(
                      pin: view.pin.copyWith(
                        icon: PlacemarkIcon.single(PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage("assets/icons/location.png"),
                          scale: 0.5,
                        )),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.52,
                  child: BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      return WeatherInfoWidget(weather: state.centerWeather);
                    },
                  ),
                ),
                const Icon(Icons.local_airport_sharp, size: 30, color: Colors.red),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    LocationPermission permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        final weather = await WeatherService().fetchTashkentOnly();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blueGrey,
                              content: Text(
                                weather != null
                                    ? "Ruxsat berilmadi. Toshkent: ${weather.temp}°C, ${weather.condition}"
                                    : "Ruxsat berilmadi. Ob-havo ma'lumotini yuklab bo'lmadi.",
                              ),
                            ),
                          );
                        }
                        return;
                      }
                    } else if (permission == LocationPermission.deniedForever) {
                      Geolocator.openLocationSettings();
                    }
                    await _mapController.toggleUserLayer(visible: true, autoZoomEnabled: true);
                  },
                  child: const Text("Lakatsiya ko'rish"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final CameraPosition? userPosition = await _mapController.getUserCameraPosition();
                    if (userPosition != null) {
                      _mapController.moveCamera(CameraUpdate.newCameraPosition(userPosition));
                    }
                  },
                  child: const Text("Hozirgi lakatsiya"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: FutureBuilder<List<WeatherModel>>(
                            future: WeatherService().fetchAllWeather(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              if (snapshot.hasError) {
                                return Text("Xatolik yuz berdi: ${snapshot.error}");
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text("Ma'lumot topilmadi");
                              }
                              final data = snapshot.data!;
                              return SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: data.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 120,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(data[index].city, style: const TextStyle(color: Colors.white)),
                                          Text("${data[index].temp}C", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                          Text("Namlik ${data[index].humidity} %", style: const TextStyle(color: Colors.white)),
                                          Text("Shamol tezligi ${data[index].windSpeed}", style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("12 viloyat obxavo"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
