

// "day": 30.29,
// "min": 23.09,
// "max": 30.29,
// "night": 24.53,
// "eve": 29.06,
// "morn": 23.26

class DailyTemp {
  double day;

  double min;

  double max;

  double night;

  double eve;

  double morn;

  DailyTemp({
    required this.day,
    required this.min,
    required this.max,
    required this.eve,
    required this.morn,
    required this.night,
  });

  factory DailyTemp.fromJson(Map<String, dynamic> json) => DailyTemp(
        day: (json['day'] as num?)?.toDouble() ?? 0.0,
        min: (json['min'] as num?)?.toDouble() ?? 0.0,
        max: (json['max'] as num?)?.toDouble() ?? 0.0,
        eve: (json['eve'] as num?)?.toDouble() ?? 0.0,
        morn: (json['morn'] as num?)?.toDouble() ?? 0.0,
        night: (json['night'] as num?)?.toDouble() ?? 0.0,
      );

  @override
  String toString() {
    return '''
     day: $day,
     min: $min
     max: $max
     eve: $eve
     morn: $morn
    ''';
  }
}
