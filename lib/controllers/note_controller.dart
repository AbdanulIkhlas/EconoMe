import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';
import '../../model/financial_model.dart';
import '../views/page_input_income.dart';
import '../views/page_input_expense.dart';
import '../views/page_detail_note.dart';
import '../controllers/other_controllers.dart';

class NoteController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final OtherController otherController = OtherController();

  Future<void> getTransactions(List<FinancialModel> listTransactions,
      Function(int) updateTotalIncome, Function(int) updateTotalExpense) async {
    var incomeTransactions = await databaseHelper.getDataPemasukan();
    var expenseTransactions = await databaseHelper.getDataPengeluaran();

    listTransactions.clear();
    listTransactions.addAll(
        incomeTransactions!.map((data) => FinancialModel.fromMap(data)));
    listTransactions.addAll(
        expenseTransactions!.map((data) => FinancialModel.fromMap(data)));

    // Sort transactions by createdAt in descending order
    listTransactions.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    final totalIncome = calculateTotalIncome(listTransactions);
    final totalExpense = calculateTotalExpense(listTransactions);

    updateTotalIncome(totalIncome);
    updateTotalExpense(totalExpense);
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

  int calculateBalance(int totalIncome, int totalExpense) {
    return totalIncome - totalExpense;
  }

  Future<void> navigateToDetail(BuildContext context,
      FinancialModel financialModel, Function updateTransactions) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailNote(financialModel: financialModel),
      ),
    );

    // Jika ada pembaruan data, perbarui daftar transaksi
    updateTransactions();
  }

  Future<void> navigateToAddPemasukan(
      BuildContext context, Function updateTransactions) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageInputIncome(),
      ),
    );

    if (result == 'save') {

    }

    // Setelah menambahkan transaksi, perbarui daftar transaksi
    updateTransactions();
  }

  Future<void> navigateToAddPengeluaran(
      BuildContext context, Function updateTransactions) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageInputExpense(),
      ),
    );

    // Setelah menambahkan transaksi, perbarui daftar transaksi
    updateTransactions();
  }

  String formatAmount(double amount) {
    if (amount < (-1000000000)) {
      return 'Susah Hidup';
    } else if (amount < 1000000) {
      return OtherController.convertToIdr(amount);
    } else if (amount < 1000000000) {
      double result = amount / 1000000;
      return OtherController.convertToIdr(result) + ' Jt';
    } else if (amount < 1000000000000) {
      double result = amount / 1000000000;
      return OtherController.convertToIdr(result) + ' M';
    } else {
      double result = amount / 1000000000000;
      return OtherController.convertToIdr(result) + ' KB';
    }
  }

  void showOptions(BuildContext context, Function updateTransactions) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xFF424242), // Background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFF4EFC2), // Box shadow color
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(modalContext); // Gunakan modalContext di sini
                  navigateToAddPemasukan(context, updateTransactions);
                },
                child: Text(
                  'Input Pemasukan',
                  style: TextStyle(color: Color(0xFFF2EFCD)), // Text color
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(modalContext); // Gunakan modalContext di sini
                  navigateToAddPengeluaran(context, updateTransactions);
                },
                child: Text(
                  'Input Pengeluaran',
                  style: TextStyle(color: Color(0xFFF2EFCD)), // Text color
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
