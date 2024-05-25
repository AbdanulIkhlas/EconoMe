import 'package:flutter/material.dart';
import '../../model/financial_model.dart';
import '../controllers/transaction_controller.dart';

class PageTransaksi extends StatefulWidget {
  const PageTransaksi({Key? key}) : super(key: key);

  @override
  State<PageTransaksi> createState() => _PageTransaksiState();
}

class _PageTransaksiState extends State<PageTransaksi> {
  final List<FinancialModel> listTransactions = [];
  final TransactionController _transactionController = TransactionController();
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _transactionController.getTransactions(
      listTransactions,
      (income) {
        setState(() {
          totalIncome = income;
        });
      },
      (expense) {
        setState(() {
          totalExpense = expense;
        });
      },
    );
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
                        _transactionController
                            .formatAmount(totalIncome.toDouble()),
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
                        _transactionController
                            .formatAmount(totalExpense.toDouble()),
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
                        _transactionController.formatAmount(
                            _transactionController.calculateBalance(
                                totalIncome, totalExpense).toDouble()),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _transactionController.calculateBalance(
                                      totalIncome, totalExpense) >=
                                  0
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
            listTransactions.isEmpty
                ? Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 200),
                    child: Center(
                      child: Text(
                        'Ups, belum ada catatan.\nYuk catat keuangan Kamu!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listTransactions.length,
                    itemBuilder: (context, index) {
                      FinancialModel transaction = listTransactions[index];
                      return GestureDetector(
                        onTap: () {
                          _transactionController.navigateToDetail(
                              context, transaction, _updateTransactions);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      _transactionController.formatAmount(
                                          int.parse(transaction.jml_uang!)
                                              .toDouble()),
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
          _transactionController.showOptions(context, _updateTransactions);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF585752),
        foregroundColor: Color(0xFFfefad4),
      ),
    );
  }

  void _updateTransactions() {
    setState(() {
      _transactionController.getTransactions(
        listTransactions,
        (income) {
          totalIncome = income;
        },
        (expense) {
          totalExpense = expense;
        },
      );
    });
  }
}
