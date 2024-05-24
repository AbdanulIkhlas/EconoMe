import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../database/DatabaseHelper.dart';
import '../../decoration/format_rupiah.dart';
import '../../model/financial_model.dart';
import 'pemasukan/page_input_pemasukan.dart';
import 'pengeluaran/page_input_pengeluaran.dart';
import 'page_detail_transaksi.dart';

class PageTransaksi extends StatefulWidget {
  const PageTransaksi({Key? key}) : super(key: key);

  @override
  State<PageTransaksi> createState() => _PageTransaksiState();
}

class _PageTransaksiState extends State<PageTransaksi> {
  List<FinancialModel> listTransactions = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  Future<void> getTransactions() async {
    var incomeTransactions = await databaseHelper.getDataPemasukan();
    var expenseTransactions = await databaseHelper.getDataPengeluaran();

    setState(() {
      listTransactions.clear();
      listTransactions.addAll(
          incomeTransactions!.map((data) => FinancialModel.fromMap(data)));
      listTransactions.addAll(
          expenseTransactions!.map((data) => FinancialModel.fromMap(data)));

      totalIncome = calculateTotalIncome(listTransactions);
      totalExpense = calculateTotalExpense(listTransactions);
    });
  }

  int calculateTotalIncome(List<FinancialModel> transactions) {
    return transactions
        .where((transaction) => transaction.tipe == 'pemasukan')
        .map((transaction) => int.parse(transaction.jml_uang!))
        .fold(0, (sum, amount) => sum + amount);
  }

  int calculateTotalExpense(List<FinancialModel> transactions) {
    return transactions
        .where((transaction) => transaction.tipe == 'pengeluaran')
        .map((transaction) => int.parse(transaction.jml_uang!))
        .fold(0, (sum, amount) => sum + amount);
  }

  int calculateBalance() {
    return totalIncome - totalExpense;
  }

  Future<void> navigateToDetail(BuildContext context, FinancialModel financialModel) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTransaksi(financialModel: financialModel),
      ),
    );

    if (result == 'update') {
      getTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EconoMe',
            style: TextStyle(fontSize: 30, color: Colors.white)),
        backgroundColor: Color(0xFFa7a597),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFa7a597),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Total Pemasukan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(CurrencyFormat.convertToIdr(totalIncome),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 20),
                  Text('Total Pengeluaran',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(CurrencyFormat.convertToIdr(totalExpense),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 20),
                  Text('Saldo',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(CurrencyFormat.convertToIdr(calculateBalance()),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listTransactions.length,
              itemBuilder: (context, index) {
                FinancialModel transaction = listTransactions[index];
                return GestureDetector(
                  onTap: () {
                    navigateToDetail(context, transaction);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(transaction.keterangan!,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Jumlah Uang: ${CurrencyFormat.convertToIdr(int.parse(transaction.jml_uang!))}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black)),
                          Text('Tanggal: ${transaction.tanggal}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFa7a597),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return Container(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(modalContext); // Gunakan modalContext di sini
                  Navigator.push(
                    modalContext, // Gunakan modalContext di sini
                    MaterialPageRoute(
                      builder: (context) => PageInputPemasukan(),
                    ),
                  );
                },
                child: Text('Input Pemasukan'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(modalContext); // Gunakan modalContext di sini
                  Navigator.push(
                    modalContext, // Gunakan modalContext di sini
                    MaterialPageRoute(
                      builder: (context) => PageInputPengeluaran(),
                    ),
                  );
                },
                child: Text('Input Pengeluaran'),
              ),
            ],
          ),
        );
      },
    );
  }
}
