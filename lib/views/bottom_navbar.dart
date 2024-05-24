import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pemasukan/page_pemasukan.dart';
import 'pengeluaran/page_pengeluaran.dart';

class BottomNavbar extends StatefulWidget {
  int selectedIndex;
  BottomNavbar({this.selectedIndex = 0});
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PagePemasukan(),
    PagePengeluaran(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
    );
  }
}
