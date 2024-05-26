import 'package:flutter/material.dart';
import '../model/financial_model.dart';
import '../database/DatabaseHelper.dart';
import 'page_input_pemasukan.dart';
import 'page_input_pengeluaran.dart';
import 'bottom_navbar.dart';
import '../services/base_network.dart';
import '../controllers/other_controllers.dart';

class DetailNote extends StatefulWidget {
  final FinancialModel financialModel;

  const DetailNote({Key? key, required this.financialModel})
      : super(key: key);

  @override
  _DetailNoteState createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  FinancialModel financialModel = FinancialModel();
  OtherController otherController = OtherController();

  int strJmlUang = 0;
  int strCheckDatabase = 0;
  double selectedRate = 1.0;
  String selectedCity = 'Europe/London';
  String selectedCurrency = 'USD';
  List<dynamic> timezones = [];
  dynamic times = [];
  Map<String,dynamic> currencies = {};
  bool _isLoadingTimezone = true;
  bool _isLoadingCurrency = true;


  @override
  void initState() {
    super.initState();
    getDatabase();
    loadTimezones();
    loadCurrency();
  }

  void loadTimezones() async {
    try {
      List<dynamic> _timezones = await BaseNetwork().fetchTimezone();
      setState(() {
        timezones = _timezones;
        _isLoadingTimezone = false;
      });
    } catch (e) {
      print("error loadTimezone ${e}");
      setState(() {
        _isLoadingTimezone = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error loadTimezone ${e}"),
      ));
    }
  }
  
  void loadCurrency() async {
    try {
      Map<String,dynamic> _currencies = await BaseNetwork().fetchCurrency();
      setState(() {
        currencies = _currencies;
        _isLoadingCurrency = false;
      });
    } catch (e) {
      print("error loadCurrency ${e}");
      setState(() {
        _isLoadingCurrency = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error loadCurrency ${e}"),
      ));
    }
  }

  Future<dynamic> loadTime(String zone) async {
    try {
      dynamic _times = await BaseNetwork().fetchTime(zone);
      setState(() {
        times = _times;
        // _isLoadingCurrency = false;
      });
      return _times;
    } catch (e) {
      print("error loadTimes ${e}");
      // setState(() {
      //   // _isLoadingCurrency = false;
      // });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error loadTimes ${e}"),
      ));
    }
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
                OtherController.convertToIdr(
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
                otherController.formatTime(widget.financialModel.createdAt!),
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
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 1,
                color: Color(0xFF6B6C67),
              ),
              SizedBox(height: 10),
              Text(
                'Konversi Waktu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              Text(
                otherController.currentTime(),
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    _isLoadingTimezone
                        ? CircularProgressIndicator()
                        : DropdownButton<String>(
                            value: selectedCity,
                            dropdownColor: Color(0xFF424242),
                            style: TextStyle(color: Color(0xFFF2EFCD)),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCity = newValue!;
                              });
                            },
                            items: timezones
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                    // You can add a similar dropdown for currencies here
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder(
                         // Panggil metode _loadTime dengan parameter selectedCity
                        future: loadTime(selectedCity),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Tampilkan indicator jika sedang loading
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            // Tampilkan pesan error jika gagal memuat data
                            return AlertDialog(
                              backgroundColor: Color(0xFF424242),
                              content: Text(
                                'Failed to load time data for $selectedCity',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          } else {
                            // Tampilkan data jika berhasil dimuat
                            final Map<String,dynamic> times = snapshot.data!;
                            final time = times.isNotEmpty ? times : null;
                            return AlertDialog(
                              backgroundColor: Color(0xFF424242),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (time != null) ...[
                                    Text(
                                      'Date: ${time['date']}',
                                      style: TextStyle(
                                          color: Color(0xFFF2EFCD),
                                          fontSize: 16),
                                    ),
                                    Text(
                                      'Time: ${time['time']}',
                                      style: TextStyle(
                                          color: Color(0xFFF2EFCD),
                                          fontSize: 16),
                                    ),
                                    Text(
                                      'Timezone: ${time['timeZone']}',
                                      style: TextStyle(
                                          color: Color(0xFFF2EFCD),
                                          fontSize: 16),
                                    ),
                                    Text(
                                      'Day of Week: ${time['dayOfWeek']}',
                                      style: TextStyle(
                                          color: Color(0xFFF2EFCD),
                                          fontSize: 16),
                                    ),
                                  ] else
                                    Text(
                                      'No data available',
                                      style: TextStyle(
                                          color: Color(0xFFF2EFCD),
                                          fontSize: 16),
                                    ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      otherController.launchURL(
                                          'https://www.google.com/search?q=waktu+sekarang+di+${selectedCity}&sca_esv=274f1da98f794c68&sca_upv=1&rlz=1C1KNTJ_enID969ID969&sxsrf=ADLYWIJ7CGRmr8qNamIZzleQrIr6IcEgrQ%3A1716652008222&ei=6AdSZqaaDbOKnesPm_CX-Ak&ved=0ahUKEwimrpyJk6mGAxUzRWcHHRv4BZ8Q4dUDCBA&uact=5&oq=waktu+sekarang+di+eropa%2Famsterdam&gs_lp=Egxnd3Mtd2l6LXNlcnAiIXdha3R1IHNla2FyYW5nIGRpIGVyb3BhL2Ftc3RlcmRhbTIEEAAYRzIEEAAYRzIEEAAYRzIEEAAYRzIEEAAYRzIEEAAYRzIEEAAYRzIEEAAYR0iKC1CDAliDAnABeAKQAQCYAQCgAQCqAQC4AQPIAQD4AQGYAgKgAg3CAgoQABiwAxjWBBhHmAMA4gMFEgExIECIBgGQBgiSBwEyoAcA&sclient=gws-wiz-serp');
                                    },
                                    child: Text('Check'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF424242),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 158, 158, 158)),
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
                          }
                        },
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
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              Text(
                OtherController.convertToIdr(
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
                    selectedRate = currencies[newValue]!;
                  });
                },
                items: currencies.keys
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
                      double amount =
                          double.parse(widget.financialModel.jml_uang!) *
                              selectedRate;
                      return AlertDialog(
                        backgroundColor: Color(0xFF424242),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'IDR to $selectedCurrency',
                              style: TextStyle(
                                color: Color(0xFFF2EFCD),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Money in IDR : Rp ${widget.financialModel.jml_uang!}',
                              style: TextStyle(
                                color: Color(0xFFF2EFCD),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              otherController.formatAmount(selectedCurrency, amount),
                              style: TextStyle(
                                color: Color(0xFFF2EFCD),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                otherController.launchURL(
                                    'https://www.google.com/search?q=${widget.financialModel.jml_uang!}+rupiah+berapa+${selectedCurrency}&sca_esv=c6cd4adb8e74364a&sca_upv=1&rlz=1C1KNTJ_enID969ID969&sxsrf=ADLYWIJv3PdcJZPsbpXu2TYezbz55hbn5Q%3A1716649550131&ei=Tv5RZsrOB_fvseMP57Wu-Ak&ved=0ahUKEwjKrY71iamGAxX3d2wGHeeaC58Q4dUDCBA&uact=5&oq=30000+rupiah+berapa+usd&gs_lp=Egxnd3Mtd2l6LXNlcnAiFzMwMDAwIHJ1cGlhaCBiZXJhcGEgdXNkMgYQABgWGB4yCBAAGIAEGKIEMggQABiABBiiBDIIEAAYgAQYogQyCBAAGIAEGKIESNZ0UItcWJRlcAV4AZABAJgB0QGgAaoJqgEFMC42LjK4AQPIAQD4AQGYAgygAtcIwgIKEAAYsAMY1gQYR8ICBBAjGCfCAggQABgHGB4YD8ICBhAAGAgYHsICCBAAGAcYCBgemAMAiAYBkAYIkgcFNS41LjKgB9Ih&sclient=gws-wiz-serp');
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
