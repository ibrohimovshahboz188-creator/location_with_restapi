final List<String> viloyatlar = [
  "Tashkent", "Andijan", "Bukhara", "Guliston", "Jizzakh",
  "Namangan", "Navoi", "Nukus", "Samarkand", "Termez", "Urgench", "Karshi"
];

class WeatherModel {
  final String city;
  final double temp;
  final String condition;

  WeatherModel({required this.city, required this.temp, required this.condition});
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'], // Shahar nomi
      temp: json['main']['temp'].toDouble(), // Harorat (double ko'rinishida)
      condition: json['weather'][0]['main'], // Ob-havo holati (Bulutli, Quyoshli va h.k.)
    );
  }
}