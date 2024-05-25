import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseNetwork {
  Future<dynamic> fetchTimezone() async {
    String url = "https://timeapi.io/api/TimeZone/AvailableTimeZones";

    final response = await http.get(Uri.parse(url));
    //print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      var bodyDecoded = jsonDecode(response.body);
      return bodyDecoded;
    } else {
      throw Exception('failed to fetch timezone');
    }
  }

  Future<dynamic> fetchTime(String zone) async {
    String url = "https://timeapi.io/api/Time/current/zone?timeZone=${zone}";

    final response = await http.get(Uri.parse(url));
    //print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      var bodyDecoded = jsonDecode(response.body);
      return bodyDecoded;
    } else {
      throw Exception('failed to fetch time');
    }
  }

  Future<dynamic> fetchCurrency() async {
    String url = "https://v6.exchangerate-api.com/v6/fe4e52059eeb81f211dac145/latest/IDR";

    final response = await http.get(Uri.parse(url));
    //print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      var bodyDecoded = jsonDecode(response.body);
      return bodyDecoded['conversion_rates'];
    } else {
      throw Exception('failed to fetch currency');
    }
  }
  // static Future<Map<String, dynamic>> getTime(String partUrl) async {
  //   final String fullUrl = "https://timeapi.io/api/Time$partUrl";
  //   _logDebug("fullUrl: $fullUrl");

  //   final http.Response response = await http.get(Uri.parse(fullUrl));
  //   _logDebug("response: ${response.body}");

  //   return _processResponse(response);
  // }

  // static Future<List<dynamic>> getTimezone() async {
  //   final String fullUrl = "https://timeapi.io/api/TimeZone/AvailableTimeZones";
  //   _logDebug("fullUrl: $fullUrl");

  //   final http.Response response = await http.get(Uri.parse(fullUrl));
  //   _logDebug("response: ${response.body}");

  //   return _processResponseList(response);
  // }

  // static Future<Map<String, dynamic>> getCurrency() async {
  //   final String fullUrl = "https://v6.exchangerate-api.com/v6/fe4e52059eeb81f211dac145/latest/IDR";
  //   _logDebug("fullUrl: $fullUrl");

  //   final http.Response response = await http.get(Uri.parse(fullUrl));
  //   _logDebug("response: ${response.body}");

  //   return _processResponse(response);
  // }

  // static Future<Map<String, dynamic>> _processResponse(
  //     http.Response response) async {
  //   final String body = response.body;
  //   if (body.isNotEmpty) {
  //     final Map<String, dynamic> jsonBody = json.decode(body);
  //     return jsonBody;
  //   } else {
  //     _logDebug("processResponse error");
  //     return {"error": true};
  //   }
  // }
  // static Future<List<dynamic>> _processResponseList(
  //     http.Response response) async {
  //   final String body = response.body;
  //   print("body _processResponseList: $body");
  //   if (body.isNotEmpty) {
  //     final List<dynamic> jsonBody = json.decode(body);
  //     return jsonBody;
  //   } else {
  //     _logDebug("processResponse error");
  //     // return "error";
  //     throw Exception("Failed to load current time");
  //   }
  // }

  // // static String _buildFullUrl(String partUrl) {
  // //   return "$_baseUrl$partUrl";
  // // }

  // static void _logDebug(String value) {
  //   print("[BASE_NETWORK] - $value");
  // }
}
