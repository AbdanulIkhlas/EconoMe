import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherController {
    static String convertToIdr(dynamic number) {
      NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: 2,
      );
      return currencyFormatter.format(number);
    }

  // Function to launch website link in a new tab
  Future<void> launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $url');
    }
  }

  // fungsi waktu sekarang
  String currentTime() {
    DateTime now = DateTime.now();
    String currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
    return currentTime;
  }

  // fungsi menampilkan zona dan jumlah
  String formatAmount(String zone, double amount) {
    String _amount = amount.toStringAsFixed(2);
    return "Money in ${zone} : ${_amount}";
  }

  //fungsi format time
  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    return '$day-$month-$year, $hour:$minute:$second WIB';
  }
}
