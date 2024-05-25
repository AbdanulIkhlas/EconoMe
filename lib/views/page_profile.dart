import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF424242),
      appBar: AppBar(
        backgroundColor: Color(0xFF585752),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                'assets/text-logo.png',
                height: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                'assets/logo.png',
                height: 60,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'PROFILE',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF0F1DA),
                  ),
                ),
                SizedBox(height: 40),
                CircleAvatar(
                  backgroundImage: AssetImage('images/foto.jpg'),
                  radius: 130,
                ),
                SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _infoProfile('Nama', 'Muhammad Abdanul Ikhlas'),
                    _infoProfile('NIM', '123210009'),
                    _infoProfile('Kelas', 'IF - B'),
                    _infoProfile('Hobi', 'Bermain Volly'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoProfile(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
