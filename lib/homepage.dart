import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_with_restapi/models/wether_models.dart';
import 'package:location_with_restapi/services/http_services.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late YandexMapController mapController;
  String addressName="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Yandex Map"),
      ),
      body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Expanded(
              flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    YandexMap(
                      onCameraPositionChanged:(cameraPosition, reson, finish)async{
                        if(finish){
                          print("Camera: $cameraPosition");
                          List<Placemark>address=
                          await placemarkFromCoordinates(cameraPosition.target.latitude, cameraPosition.target.longitude);
                          if(address.isNotEmpty){
                            addressName=address.first.street??"";
                            setState(() {

                            });
                          }
                        }
                      },
                      onMapCreated: (controller){
                        mapController=controller;
                      },
                      onUserLocationAdded: (view)async{
                        return view.copyWith(
                            pin: view.pin.copyWith(
                                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                  image: BitmapDescriptor.fromAssetImage("assets/icons/location.png",),
                                  scale: 0.5,
                                ))
                            )
                        );
                      },
                    ),
                    Icon(Icons.local_airport_sharp, size: 30, color: Colors.red,),
                  ],
                )
            ),
              Expanded(
                child: Column(
                  children: [
                    Text("Viloyat $addressName"),
               ElevatedButton(onPressed: ()async{
                 LocationPermission permission= await Geolocator.checkPermission();
                 if(permission==LocationPermission.denied){
                 permission= await Geolocator.requestPermission();
                 if(permission==LocationPermission.denied){
                   final weather = await fetchTashkentonly();

                   // 3. SnackBar ichida ma'lumotni ko'rsatish
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
                   return;
                 }
                 }else if(permission==LocationPermission.deniedForever){
                 Geolocator.openLocationSettings();
                 }
               await  mapController.toggleUserLayer(visible: true, autoZoomEnabled: true);
               },
               child: Text("Lakatsiya ko'rish")),




                 ElevatedButton(onPressed: ()async{
                   CameraPosition? userPosition=await mapController.getUserCameraPosition();
                   if(userPosition !=null){
                     mapController.moveCamera(CameraUpdate.newCameraPosition(userPosition));
                   }
                 },
                     child: Text("Hozirgi lakatsiya")),

                    ElevatedButton(onPressed: (){
                      showDialog(context: context,
                          builder: (context){
                        return AlertDialog(
                          content: FutureBuilder<List<WeatherModel>>(future: fetchAllWeather(),
                              builder:(context, snapshot){
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
                                  itemBuilder: (context, index){
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
                                         Text("Namlik ${data[index].humidity} %", style: const TextStyle(color: Colors.white, )),
                                         Text("Shamol tezligi ${data[index].windSpeed}", style: const TextStyle(color: Colors.white, ))
                                       ],
                                     ),
                                   );
                              }),
                            );
                              }),
                        );
                          });
                      },
                        child: Text("12 viloyat obxavo"))
                  ],

              ),
          ),
        ],
      ),
    );
  }
}
