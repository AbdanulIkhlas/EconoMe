import 'package:flutter/material.dart';
import './views/pemasukan/page_pemasukan.dart';
import './views/pengeluaran/page_pengeluaran.dart';

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
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    PagePemasukan(),
    PagePengeluaran(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFa7a597),
          title: Text(
            'EconoMe',
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: 'Pemasukan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.unarchive_outlined),
              label: 'Pengeluaran',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black26,
          backgroundColor: Color(0xFFa7a597),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
