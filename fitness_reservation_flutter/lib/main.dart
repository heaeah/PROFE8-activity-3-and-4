import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_app_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';

void main() {
  runApp(const FitnessReservationApp());
}

class FitnessReservationApp extends StatelessWidget {
  const FitnessReservationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Class Reservation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: Colors.orange,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // Named routes (Requirement 7)
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/app': (context) => const MainAppScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}
