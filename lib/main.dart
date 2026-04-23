import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';

void main() => runApp(const PMSApp());

class PMSApp extends StatelessWidget {
  const PMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PMS Professional',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MainNavigationScreen(),
    );
  }
}
