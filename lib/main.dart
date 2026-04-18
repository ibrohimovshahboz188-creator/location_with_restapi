import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_with_restapi/presintation/screens/homepage.dart';
import 'cubits/weather_cubit.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (context) => WeatherCubit(),
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}