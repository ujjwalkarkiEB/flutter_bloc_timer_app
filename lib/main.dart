import 'package:flutter/material.dart';
import 'package:timer_app/timer/timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            iconSize: 28,
          ))),
      home: const TimerScreen(),
    );
  }
}
