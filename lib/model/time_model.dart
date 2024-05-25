class Time {
  final int? year;
  final int? month;
  final int? day;
  final int? hour;
  final int? minute;
  final int? seconds;
  final int? milliSeconds;
  final String? dateTime;
  final String? date;
  final String? time;
  final String? timeZone;
  final String? dayOfWeek;
  final bool? dstActive;

  Time({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.seconds,
    this.milliSeconds,
    this.dateTime,
    this.date,
    this.time,
    this.timeZone,
    this.dayOfWeek,
    this.dstActive,
  });

  Time.fromJson(Map<String, dynamic> json)
    : year = json['year'] as int?,
      month = json['month'] as int?,
      day = json['day'] as int?,
      hour = json['hour'] as int?,
      minute = json['minute'] as int?,
      seconds = json['seconds'] as int?,
      milliSeconds = json['milliSeconds'] as int?,
      dateTime = json['dateTime'] as String?,
      date = json['date'] as String?,
      time = json['time'] as String?,
      timeZone = json['timeZone'] as String?,
      dayOfWeek = json['dayOfWeek'] as String?,
      dstActive = json['dstActive'] as bool?;

  Map<String, dynamic> toJson() => {
    'year' : year,
    'month' : month,
    'day' : day,
    'hour' : hour,
    'minute' : minute,
    'seconds' : seconds,
    'milliSeconds' : milliSeconds,
    'dateTime' : dateTime,
    'date' : date,
    'time' : time,
    'timeZone' : timeZone,
    'dayOfWeek' : dayOfWeek,
    'dstActive' : dstActive
  };
}