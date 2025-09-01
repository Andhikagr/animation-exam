import 'package:animation_exam/food_one/food_one_splash.dart';
// ignore: unused_import
import 'package:animation_exam/simple/simple_splash.dart';
// ignore: unused_import
import 'package:animation_exam/travel/travel_splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home:
          // TravelSplash(),
          // SimpleSplash(),
          FoodOneSplash(),
    );
  }
}
