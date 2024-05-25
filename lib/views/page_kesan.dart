import 'package:flutter/material.dart';

class PesanKesanPage extends StatelessWidget {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pesan & Kesan',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFF4F5CA),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kesannya, selama belajar TPM ini cukup menantang, karena requirement tugas-tugas yang diberikan cukup membuat keteteran, terutama yang project akhir ini. Kemudian untuk pesannya, semoga tetap gacor!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFF4F5CA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
