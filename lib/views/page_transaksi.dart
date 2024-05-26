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
  final List<FinancialModel> _filteredTransactions = [];
  final TransactionController _transactionController = TransactionController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTransactions);
    _fetchTransactions();
  }

  void _fetchTransactions() {
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
    ).then((_) {
      setState(() {
        _filteredTransactions.clear();
        _filteredTransactions.addAll(listTransactions);
      });
    });
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTransactions.clear();
        _filteredTransactions.addAll(listTransactions);
      } else {
        _filteredTransactions.clear();
        _filteredTransactions.addAll(listTransactions.where((transaction) {
          return transaction.keterangan!.toLowerCase().contains(query) ||
              transaction.tanggal!.toLowerCase().contains(query);
        }).toList());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF424242),
      appBar: AppBar(
        backgroundColor: Color(0xFF585752),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari transaksi...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFFffffce)),
                ),
                style: TextStyle(color: Color(0xFFffffce), fontSize: 18),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      'assets/text-logo.png',
                      height: 30,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Color(0xFFffffce),
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
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
                          color: Color(0xFFffffce),
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
                          color: Color(0xFFffffce),
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
                          color: Color(0xFFffffce),
                        ),
                      ),
                      Text(
                        _transactionController.formatAmount(
                            _transactionController
                                .calculateBalance(totalIncome, totalExpense)
                                .toDouble()),
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
            _filteredTransactions.isEmpty
                ? Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 200),
                    child: Center(
                      child: Text(
                        'Ups, belum ada catatan.\nYuk catat keuangan Kamu!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffffce),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      FinancialModel transaction = _filteredTransactions[index];
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
      _fetchTransactions();
    });
  }
}
