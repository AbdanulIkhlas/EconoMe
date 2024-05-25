import 'package:flutter/material.dart';
import './views/bottom_navbar.dart';
import 'controllers/initializer.dart';

// Definisikan warna utama
const int primaryColorHex = 0xFF5c5c54;
const MaterialColor primarySwatch = MaterialColor(
  primaryColorHex,
  <int, Color>{
    50: Color(0xFFe0e0e0), // 10%
    100: Color(0xFFb3b3b3), // 20%
    200: Color(0xFF808080), // 30%
    300: Color(0xFF4d4d4d), // 40%
    400: Color(0xFF262626), // 50%
    500: Color(primaryColorHex), // 60%
    600: Color(0xFF1f1f1f), // 70%
    700: Color(0xFF1a1a1a), // 80%
    800: Color(0xFF141414), // 90%
    900: Color(0xFF0d0d0d), // 100%
  },
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: primarySwatch,
        primaryColor: Color(primaryColorHex),
        scaffoldBackgroundColor: Color(0xFF424242),
        splashColor: Colors.white,
        highlightColor: Colors.white,
        brightness: Brightness.dark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(primaryColorHex),
        ),
        cardTheme: const CardTheme(
          surfaceTintColor: Color(0xFFa7a597),
        ),
        dialogTheme: const DialogTheme(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      // home: BottomNavbar(),
      home: Initializer(),
    );
  }
}
