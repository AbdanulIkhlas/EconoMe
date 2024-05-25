import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/DatabaseHelper.dart';
import '../../model/financial_model.dart';
import 'bottom_navbar.dart';

class InputTransaksi extends StatefulWidget {
  final FinancialModel? financialModel;

  InputTransaksi({this.financialModel});

  @override
  _InputTransaksiState createState() => _InputTransaksiState();
}

class _InputTransaksiState extends State<InputTransaksi> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController? keterangan;
  TextEditingController? tanggal;
  TextEditingController? jml_uang;
  String? selectedType;

  @override
  void initState() {
    keterangan = TextEditingController(
        text: widget.financialModel == null ? '' : widget.financialModel!.keterangan);
    tanggal = TextEditingController(
        text: widget.financialModel == null ? '' : widget.financialModel!.tanggal);
    jml_uang = TextEditingController(
        text: widget.financialModel == null ? '' : widget.financialModel!.jml_uang);
    selectedType = widget.financialModel == null ? '' : widget.financialModel!.tipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFFa7a597),
        title: Text('Form Data Keuangan',
            style: const TextStyle(fontSize: 14, color: Colors.white)),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            value: selectedType,
            onChanged: (String? value) {
              setState(() {
                selectedType = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Tipe',
              labelStyle: TextStyle(fontSize: 14, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            items: <String>['Pemasukan', 'Pengeluaran'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: keterangan,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
                labelText: 'Keterangan',
                labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          SizedBox(height: 20),
          TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                            onPrimary: Colors.white,
                            onBackground: Colors.white),
                        datePickerTheme: const DatePickerThemeData(
                          backgroundColor: Color.fromARGB(255, 197, 197, 197),
                          headerBackgroundColor: Color(0xFFa7a597),
                          headerForegroundColor: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(9999));
              if (pickedDate != null) {
                tanggal!.text = DateFormat('dd MMM yyyy').format(pickedDate);
              }
            },
            controller: tanggal,
            decoration: InputDecoration(
                labelText: 'Tanggal',
                labelStyle:
                const TextStyle(fontSize: 14, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          SizedBox(height: 20),
          TextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            controller: jml_uang,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
                labelText: 'Jumlah Uang',
                labelStyle:
                const TextStyle(fontSize: 14, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFa7a597)),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (keterangan!.text.toString() == '' ||
                          tanggal!.text.toString() == '' ||
                          jml_uang!.text.toString() == '' ||
                          selectedType == '') {
                        const snackBar = SnackBar(
                            content:
                            Text("Ups, form tidak boleh ada yang kosong!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        upsertData();
                      }
                    },
                    child: Center(
                      child: (widget.financialModel == null)
                          ? Text(
                        'Tambah Data',
                        style:
                        TextStyle(fontSize: 14, color: Colors.white),
                      )
                          : Text(
                        'Update Data',
                        style:
                        TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> upsertData() async {
    if (widget.financialModel != null) {
      //update
      await databaseHelper.updateData(FinancialModel.fromMap({
        'id': widget.financialModel!.id,
        'tipe': selectedType,
        'keterangan': keterangan!.text,
        'jml_uang': jml_uang!.text,
        'tanggal': tanggal!.text
      }), keterangan!.text);
      Navigator.pop(context, 'update');
    } else {
      //insert
      await databaseHelper.saveData(FinancialModel(
        tipe: selectedType,
        keterangan: keterangan!.text,
        jml_uang: jml_uang!.text,
        tanggal: tanggal!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
