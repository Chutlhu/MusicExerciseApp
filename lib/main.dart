import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bass_workout_app/data/workout_data.dart';
import 'pages/home_page.dart';

void main() async {

  // initialize hive
  await Hive.initFlutter();

  // open a hive box
  await Hive.openBox('workouts_db2');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: const MaterialApp(
        // debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
