import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examflutter/core/services/api_service.dart';
import 'package:examflutter/core/services/auth_service.dart';
import 'package:examflutter/features/auth/login_screen.dart';
import 'package:examflutter/features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'BadWallet',
        theme: ThemeData(
          primaryColor: const Color(0xFF667EEA),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF667EEA),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            if (authService.isLoggedIn) {
              return const DashboardScreen();
            }
            return const LoginScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}