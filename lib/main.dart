import 'package:flutter/material.dart';
import 'package:location_with_restapi/homepage.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Myapp());
}
class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
