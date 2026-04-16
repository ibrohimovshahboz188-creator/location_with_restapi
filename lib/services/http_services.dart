import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location_with_restapi/models/wether_models.dart';
 Future<List<WeatherModel>>fetchAllWeather()async{

 String apiKey="9ac4331294253137ffa5e10cf72cd1d4";
 List<WeatherModel> weatherList=[];
 List<Future> futures=viloyatlar.map((shahar){
   String url ="https://api.openweathermap.org/data/2.5/weather?q=$shahar&appid=$apiKey&units=metric";
   return http.get(Uri.parse(url));
 }).toList();

 var response= await Future.wait(futures);
 for (var response in response) {
   if (response.statusCode == 200) {
     var data = jsonDecode(response.body);
     weatherList.add(WeatherModel(
       city: data['name'],
       temp: data['main']['temp'].toDouble(),
       condition: data['weather'][0]['main'],
       windSpeed: data['wind']['speed'].toDouble(), // 'json' emas, 'data' bo'lishi kerak
       humidity: data['main']['humidity'],          // 'json' emas, 'data' bo'lishi kerak
     ));
   }
 }
 return weatherList;
 }

 Future<WeatherModel?> fetchTashkentonly()async{
   String apiKey="9ac4331294253137ffa5e10cf72cd1d4";
   final url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=Tashkent&appid=$apiKey&units=metric");
   try {
     final  response=await http.get(url);
     if(response.statusCode==200){
       return WeatherModel.fromJson(jsonDecode(response.body));
     }

   }catch (e){
     print("$e");
   }
   return null;
 }

 Future<WeatherModel?> fetchWeatherByCoords(double lat, double lon)async{
   String apiKey="9ac4331294253137ffa5e10cf72cd1d4";
   final url=Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric");
   try{
     final response=await http.get(url);
     if(response.statusCode==200){
       return WeatherModel.fromJson(jsonDecode(response.body));
     }
   }catch (e){
     print("Obxavo olishda xatolik $e");

   }
   return null;
 }