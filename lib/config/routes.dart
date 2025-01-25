import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/mindfulness_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/subscription_screen.dart';

final routes = {
  '/': (context) => const HomeScreen(),
  '/mindfulness': (context) => const MindfulnessScreen(),
  '/stats': (context) => const StatsScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/subscription': (context) => const SubscriptionScreen(),
};

final onGenerateRoute = (RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) => const HomeScreen(),
  );
};

final onUnknownRoute = (RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Página no encontrada'),
      ),
    ),
  );
}; 