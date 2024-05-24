import 'package:flutter/material.dart';
import 'pemasukan/page_pemasukan.dart';
import 'pengeluaran/page_pengeluaran.dart';
import 'page_transaksi.dart';

class BottomNavbar extends StatefulWidget {
  final int selectedIndex;

  BottomNavbar({this.selectedIndex = 0});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PageTransaksi(),
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(Icons.request_quote)
                : Icon(Icons.request_quote_outlined),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(Icons.archive)
                : Icon(Icons.archive_outlined),
            label: 'Pemasukan',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(Icons.unarchive)
                : Icon(Icons.unarchive_outlined),
            label: 'Pengeluaran',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFfefad4),
        unselectedItemColor: Color(0xFFadaa9c),
        backgroundColor: Color(0xFF585752),
        onTap: _onItemTapped,
      ),
    );
  }
}
