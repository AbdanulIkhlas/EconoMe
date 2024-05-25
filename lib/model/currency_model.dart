class Currency {
  final String result;
  final String documentation;
  final String termsOfUse;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final int timeNextUpdateUnix;
  final String timeNextUpdateUtc;
  final String baseCode;
  final Map<String, double> conversionRates;

  Currency({
    required this.result,
    required this.documentation,
    required this.termsOfUse,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.baseCode,
    required this.conversionRates,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      result: json['result'],
      documentation: json['documentation'],
      termsOfUse: json['terms_of_use'],
      timeLastUpdateUnix: json['time_last_update_unix'],
      timeLastUpdateUtc: json['time_last_update_utc'],
      timeNextUpdateUnix: json['time_next_update_unix'],
      timeNextUpdateUtc: json['time_next_update_utc'],
      baseCode: json['base_code'],
      conversionRates: Map<String, double>.from(json['conversion_rates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'documentation': documentation,
      'terms_of_use': termsOfUse,
      'time_last_update_unix': timeLastUpdateUnix,
      'time_last_update_utc': timeLastUpdateUtc,
      'time_next_update_unix': timeNextUpdateUnix,
      'time_next_update_utc': timeNextUpdateUtc,
      'base_code': baseCode,
      'conversion_rates': conversionRates,
    };
  }
}
