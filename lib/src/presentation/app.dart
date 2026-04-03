import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class OsteriaApp extends StatelessWidget {
  const OsteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Osteria Romagnola',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFAB4E1A),
          secondary: const Color(0xFFB17A3D),
        ),
        scaffoldBackgroundColor: const Color(0xFF130D0E),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
      ),
      home: const HomeScreen(),
    );
  }
}

