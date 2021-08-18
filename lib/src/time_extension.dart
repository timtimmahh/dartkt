import 'package:intl/intl.dart';

class DurationFormat {
  static const String DAY = 'd';
  static const String HOUR = 'H';
  static const String MINUTE = 'm';
  static const String SECOND = 's';

  String? _pattern;

  DurationFormat([this._pattern]);

  String format(Duration duration) => pattern.replaceAllMapped(
      RegExp('(%)(d+|H+|m+|s+)'),
      (Match m) => _valueFor(m.group(2), duration).toString());

  int _valueFor(String? match, Duration duration) {
    switch (match?.substring(0, 1)) {
      case DAY:
        return duration.inDays;
      case HOUR:
        return duration.inHours.remainder(24);
      case MINUTE:
        return duration.inMinutes.remainder(60);
      case SECOND:
        return duration.inSeconds.remainder(60);
      default:
        return 0;
    }
  }

  String get pattern =>
      _pattern ??= '%d days, %H hours, %m minutes, %s seconds';
}

extension DurationExtension on Duration {
  String format([String? pattern]) => DurationFormat(pattern).format(this);
}

extension Date on DateTime {
  static Duration timeUntil(DateTime time) => time.difference(now(time.isUtc));

  static DateTime now([bool utc = false]) =>
      utc ? DateTime.now().toUtc() : DateTime.now();

  static DateTime parse(String formattedString, [bool utc = false]) =>
      utc && !formattedString.endsWith('Z')
          ? DateTime.parse(formattedString + 'Z')
          : DateTime.parse(formattedString);

  static DateTime? tryParse(String formattedString, [bool utc = false]) =>
      utc && !formattedString.endsWith('Z')
          ? DateTime.tryParse(formattedString + 'Z')
          : DateTime.tryParse(formattedString);

  static DateTime fromMillisecondsSinceEpoch(int millisecondsSinceEpoch,
          {bool isUtc = false}) =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch, isUtc: isUtc);

  static DateTime fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch,
          {bool isUtc = false}) =>
      DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: isUtc);

  String format([String? newPattern, String? locale]) =>
      DateFormat(newPattern, locale).format(this);
}
