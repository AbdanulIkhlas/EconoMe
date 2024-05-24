import 'package:flutter/material.dart';
import '../../model/financial_model.dart';
import '../../decoration/format_rupiah.dart';

class DetailTransaksi extends StatelessWidget {
  final FinancialModel financialModel;

  const DetailTransaksi({Key? key, required this.financialModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color(0xFFa7a597), // Warna latar belakang
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keterangan:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              financialModel.keterangan!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Jumlah Uang:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              CurrencyFormat.convertToIdr(int.parse(financialModel.jml_uang!)),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Tanggal:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              financialModel.tanggal!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
