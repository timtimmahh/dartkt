import 'package:intl/intl.dart';

import 'pair_extension.dart';

class DurationFormat {
  static const String DAY = 'd';
  static const String HOUR = 'H';
  static const String MINUTE = 'm';
  static const String SECOND = 's';

  String? _pattern;
  final bool _showZeroes;

  DurationFormat([this._pattern, this._showZeroes = false]);

  String format(Duration duration) {
    var showingValue = {
      'days': true,
      'hours': true,
      'minutes': true,
      'seconds': true
    };
    return pattern.replaceAllMapped(RegExp('(%)(d+|H+|m+|s+)([\\s\\w,]+)'),
        (Match m) {
      var value = _valueFor(m.group(2), duration, showingValue);
      return !value.right ? '' : '${value.left.toString()}${m.group(3)}';
    });
  }

  Pair<int, bool> _valueFor(
      String? match, Duration duration, Map<String, bool> showingValue) {
    switch (match?.substring(0, 1)) {
      case DAY:
        var day = duration.inDays;
        showingValue['days'] = (!_showZeroes && day != 0) || _showZeroes;
        return Pair.of(day, showingValue['days']!);
      case HOUR:
        var hour = duration.inHours.remainder(24);
        showingValue['hours'] =
            showingValue['days']! || (!_showZeroes && hour != 0) || _showZeroes;
        return Pair.of(hour, showingValue['hours']!);
      case MINUTE:
        var minute = duration.inMinutes.remainder(60);
        showingValue['minutes'] = showingValue['hours']! ||
            (!_showZeroes && minute != 0) ||
            _showZeroes;
        return Pair.of(minute, showingValue['minutes']!);
      case SECOND:
        var second = duration.inSeconds.remainder(60);
        showingValue['seconds'] = showingValue['seconds']! ||
            (!_showZeroes && second != 0) ||
            _showZeroes;
        return Pair.of(second, showingValue['seconds']!);
      default:
        return Pair.of(0, false);
    }
  }

  String get pattern =>
      _pattern ??= '%d days, %H hours, %m minutes, %s seconds';
}

extension DurationExtension on Duration {
  String format([String? pattern, bool showZeroes = false]) =>
      DurationFormat(pattern, showZeroes).format(this);
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

  bool operator <(DateTime other) => isBefore(other);

  bool operator >(DateTime other) => isAfter(other);

  bool operator <=(DateTime other) =>
      isBefore(other) || isAtSameMomentAs(other);

  bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);
}
