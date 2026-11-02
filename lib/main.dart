import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GfrpCapacityApp());
}

/// Root widget for the GFRP-RC Flexural Capacity Analyzer
class GfrpCapacityApp extends StatelessWidget {
  const GfrpCapacityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GFRP-RC Beam Capacity Analyzer | ICEC 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
