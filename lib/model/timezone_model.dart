class Timezone {
  final List<String> timezones;

  Timezone({required this.timezones});

  factory Timezone.fromJson(List<dynamic> json) {
    return Timezone(
      timezones: List<String>.from(json),
    );
  }

  List<dynamic> toJson() {
    return List<dynamic>.from(timezones);
  }
}
