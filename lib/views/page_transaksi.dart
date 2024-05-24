import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../database/DatabaseHelper.dart';
import '../../decoration/format_rupiah.dart';
import '../../model/financial_model.dart';
import 'page_input_pemasukan.dart';
import 'page_input_pengeluaran.dart';
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
      // Sort transactions by date in descending order
      listTransactions.sort((a, b) => b.tanggal!.compareTo(a.tanggal!));

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

  Future<void> navigateToDetail(
      BuildContext context, FinancialModel financialModel) async {
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

  String formatAmount(int amount) {
    if (amount < (-1000000000)) {
      return 'Susah Hidup';
    } else
    if (amount < 1000000) {
      return 'Rp ${amount.toString()}';
    } else if (amount < 1000000000) {
      double result = amount / 1000000;
      return 'Rp ${result.toStringAsFixed(0)} Jt';
    } else if (amount < 1000000000000) {
      double result = amount / 1000000000;
      return 'Rp ${result.toStringAsFixed(0)} M';
    } else {
      double result = amount / 1000000000000;
      // kemungkinan kemungkinan
      return 'Rp ${result.toStringAsFixed(0)} KB';
    }
  }


  Future<void> navigateToAddPemasukan(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageInputPemasukan(),
      ),
    );
    getTransactions();
  }

  Future<void> navigateToAddPengeluaran(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageInputPengeluaran(),
      ),
    );
    getTransactions();
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF585752),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Pemasukan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatAmount(totalIncome),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Pengeluaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatAmount(totalExpense),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Saldo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatAmount(calculateBalance()),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: calculateBalance() >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xFFa0a08d)),
                      ),
                      color: Color(0xFF424242),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    transaction.keterangan!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFfefad4),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${transaction.tanggal}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFfefad4),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 130,
                              child: Text(
                                formatAmount(int.parse(transaction.jml_uang!)),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: transaction.tipe == 'pengeluaran'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 80.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF585752),
        foregroundColor: Color(0xFFfefad4),
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
                  navigateToAddPemasukan(context);
                },
                child: Text('Input Pemasukan'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(modalContext); // Gunakan modalContext di sini
                  navigateToAddPengeluaran(context);
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
