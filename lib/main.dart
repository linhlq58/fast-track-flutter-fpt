import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_track_flutter_fpt/providers/habit_provider.dart';
import 'package:fast_track_flutter_fpt/screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitProvider(),
      child: const HabitTrackerApp(),
    )
  );
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}