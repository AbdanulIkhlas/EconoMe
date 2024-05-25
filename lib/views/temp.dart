import 'package:flutter/material.dart';
import '../model/financial_model.dart';
import '../decoration/format_rupiah.dart';
import '../database/DatabaseHelper.dart';
import 'page_input_pemasukan.dart';
import 'page_input_pengeluaran.dart';
import 'bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String selectedCity = 'MAKASSAR';
  String selectedCurrency = 'USD';

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
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PageInputPengeluaran(financialModel: financialModel)));
      if (result == 'update') {
        await updateData();
      }
    } else if (type == 'pemasukan') {
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PageInputPemasukan(financialModel: financialModel)));
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

  // Function to launch website link in a new tab
  void _launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Color(0xFF424242),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Keterangan:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                widget.financialModel.keterangan!,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Jumlah Uang:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                CurrencyFormat.convertToIdr(
                    int.parse(widget.financialModel.jml_uang!)),
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Tanggal:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                widget.financialModel.tanggal!,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Create At:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                widget.financialModel.createdAt!,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      editData(context, widget.financialModel.tipe!,
                          widget.financialModel);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _confirmDelete(context, widget.financialModel);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      'Hapus',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Color(0xFF6B6C67),
              ),
              Text(
                'Konversi Waktu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.financialModel.createdAt!.split(' ')[1],
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedCity,
                dropdownColor: Color(0xFF424242),
                style: TextStyle(color: Color(0xFFF2EFCD)),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                  });
                },
                items: <String>['MAKASSAR', 'JAYAPURA', 'JAKARTA', 'LONDON']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFF424242),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedCity,
                              style: TextStyle(
                                color: Color(0xFFF2EFCD),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _launchLink(
                                    'https://www.google.com/search?q=$selectedCity');
                              },
                              child: Text('Check'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF424242),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 158, 158, 158)),
                                shadowColor: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF424242),
                  side: BorderSide(color: Color.fromARGB(255, 154, 154, 154)),
                  shadowColor: Colors.black,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Show Selected City',
                  style: TextStyle(
                    color: Color(0xFFF2EFCD),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Konversi Uang:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                CurrencyFormat.convertToIdr(
                    int.parse(widget.financialModel.jml_uang!)),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedCurrency,
                dropdownColor: Color(0xFF424242),
                style: TextStyle(color: Color(0xFFF2EFCD)),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue!;
                  });
                },
                items: <String>['USD', 'EUR', 'IDR']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFF424242),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedCurrency,
                              style: TextStyle(
                                color: Color(0xFFF2EFCD),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _launchLink(
                                    'https://www.google.com/search?q=$selectedCurrency');
                              },
                              child: Text('Check'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF424242),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 158, 158, 158)),
                                shadowColor: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                            ),
                            
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF424242),
                  side: BorderSide(color: Color.fromARGB(255, 158, 158, 158)),
                  shadowColor: Colors.black,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Show Selected Currency',
                  style: TextStyle(
                    color: Color(0xFFF2EFCD),
                  ),
                ),
              ),
            ],
          ),
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
        content: Text('Yakin ingin menghapus data ini?',
            style: TextStyle(color: Color(0xFFF2EFCD))),
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
