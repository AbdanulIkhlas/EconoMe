import 'package:flutter/material.dart';
import '../model/financial_model.dart';
import '../decoration/format_rupiah.dart';
import '../database/DatabaseHelper.dart';
import '../decoration/format_rupiah.dart';
import 'page_input_pemasukan.dart';
import 'page_input_pengeluaran.dart';
import 'bottom_navbar.dart';

class DetailTransaksi extends StatefulWidget {
  final FinancialModel financialModel;

  const DetailTransaksi({Key? key, required this.financialModel})
      : super(key: key);

  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  FinancialModel financialModel = FinancialModel();
  int strJmlUang = 0;
  int strCheckDatabase = 0;

  @override
  void initState() {
    super.initState();
    getDatabase();
  }

  Future<void> getDatabase() async {
    var checkDB = await databaseHelper.cekDataDatabase();
    setState(() {
      if (checkDB == 0) {
        strCheckDatabase = 0;
        strJmlUang = 0;
      } else {
        strCheckDatabase = checkDB!;
      }
    });
  }



  Future<void> deleteData(FinancialModel financialModel) async {
    var result = await databaseHelper.deleteTransaksi(
        financialModel.id!, financialModel.tipe!);
    if (result != null && result > 0) {
      print('Data berhasil dihapus');
      await getDatabase();
    } else {
      print('Gagal menghapus data');
    }
  }

  Future<void> editData(
    BuildContext context, String type, FinancialModel financialModel) async {
    if (type == 'pengeluaran') {
      var result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PageInputPengeluaran(financialModel: financialModel)));
      if (result == 'update') {
        await updateData();
      }
    } else if (type == 'pemasukan') {
      var result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PageInputPemasukan(financialModel: financialModel)));
      if (result == 'update') {
        await updateData();
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavbar(),
      ),
    );
  }

  Future<void> updateData() async {
    await getDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.all(20),
        color: Color(0xFFa7a597),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keterangan:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.financialModel.keterangan!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Jumlah Uang:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              CurrencyFormat.convertToIdr(
                  int.parse(widget.financialModel.jml_uang!)),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Tanggal:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.financialModel.tanggal!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Create At:',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.financialModel.createdAt!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    editData(context, widget.financialModel.tipe!, widget.financialModel);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _confirmDelete(context, widget.financialModel);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Hapus',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, FinancialModel financialModel) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color(0xFF424242),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color(0xFFF4EFC2)),
      ),
      contentTextStyle: TextStyle(color: Color(0xFFF2EFCD)),
      title: Text('Hapus Data', style: TextStyle(color: Color(0xFFF2EFCD))),
      content: Text('Yakin ingin menghapus data ini?', style: TextStyle(color: Color(0xFFF2EFCD))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            deleteData(financialModel);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavbar(),
              ),
            );
          },
          child: Text('Ya', style: TextStyle(color: Color(0xFFF2EFCD))),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Tidak', style: TextStyle(color: Color(0xFFF2EFCD))),
        ),
      ],
      elevation: 8.0, // Adding box shadow
    ),
  );
}


}
