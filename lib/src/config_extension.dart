import 'dart:io';

import 'package:dartkt/src/list_extension.dart';
import 'package:dartkt/src/map_extension.dart';
import 'package:dartkt/src/object_extension.dart';
import 'package:dartkt/src/pair_extension.dart';

class Config {
  static var _config = <String, String>{};
  static void loadFromPath(String path) => loadFromFile(File(path));

  static void loadFromFile(File file) => _config = file
      .readAsLinesSync()
      .skipEmptyLine()
      .map2((line) => line.split('=').let((c) => Pair(c[0], c[1])))
      .toMap();

  static String? get(String name) => _config[name];

  static void set(String name, String value) => _config[name] = value;
  static void saveToPath(String path) => saveToFile(File(path));
  static void saveToFile(File file) => file.writeAsStringSync(
      _config.mapToList((key, value) => '$key=$value').join('\n'));
}
