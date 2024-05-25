// import 'base_network.dart';
// import '../model/time_model.dart';
// import '../model/timezone_model.dart';
// import '../model/currency_model.dart';

// class ApiDataSource {
//   static final ApiDataSource _instance = ApiDataSource._internal();

//   factory ApiDataSource() {
//     return _instance;
//   }

//   ApiDataSource._internal();
  
//   Future<List<Time>> loadTime(String zone) async {
//     final response = await BaseNetwork.getTime("/current/zone?timeZone=$zone");
//     if (response.containsKey('data')) {
//       final List<dynamic> timeJson = response['data'];
//       return timeJson.map((json) => Time.fromJson(json)).toList();
//     } else {
//       throw Exception("Failed to load current time");
//     }
//   }

//   Future<List<Currency>> loadCurrency() async {
//     final response = await BaseNetwork.getCurrency();
//     if (response.containsKey('data')) {
//       final List<dynamic> currencyJson = response['data'];
//       return currencyJson.map((json) => Currency.fromJson(json)).toList();
//     } else {
//       throw Exception("Failed to load current time");
//     }
//   }

//   Future<List<Timezone>> loadTimezone() async {
//     final response = await BaseNetwork.getTimezone();
//     // if (response) {
//     final List<dynamic> timezoneJson = response;
//     return timezoneJson.map((json) => Timezone.fromJson(json)).toList();
//     // } else {
//     // }
//   }
// }
