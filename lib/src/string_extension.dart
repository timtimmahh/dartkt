import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dartkt/src/list_extension.dart';
import 'package:dartkt/src/object_extension.dart';
import 'package:dartkt/src/pair_extension.dart';

extension KTStringExtension on String {
  // kotlin
  String substringBefore(Pattern pattern) =>
      indexOf(pattern).let((idx) => idx == -1 ? this : substring(0, idx));

  String substringAfter(Pattern pattern) {
    if (pattern is RegExp) {
      return pattern.firstMatch(this)?.let((it) => substring(it.end, length)) ??
          this;
    }
    return indexOf(pattern).let((idx) =>
        idx == -1 ? this : substring(idx + pattern.toString().length, length));
  }

  String substringBeforeLast(Pattern pattern) =>
      lastIndexOf(pattern).let((idx) => idx == -1 ? this : substring(0, idx));

  String substringAfterLast(Pattern pattern) {
    if (pattern is RegExp) {
      return pattern.hasMatch(this)
          ? pattern.allMatches(this).last.let((it) => substring(it.end, length))
          : this;
    }
    return lastIndexOf(pattern).let((idx) =>
        idx == -1 ? this : substring(idx + pattern.toString().length, length));
  }

  String removeFirst(Pattern pattern) => replaceFirst(pattern, '');

  String removeAll(Pattern pattern) => replaceAll(pattern, '');

  String removeRange(int startIdx, int endIdx) {
    if (endIdx < startIdx) {
      throw Exception(
          'End index ($endIdx) is less than start index ($startIdx).');
    }
    return endIdx == startIdx ? this : replaceRange(startIdx, endIdx, '');
  }

  String removePrefix(Pattern pattern) =>
      startsWith(pattern) ? replaceFirst(pattern, '') : this;

  String removeSuffix(Pattern pattern) => endsWith(pattern.toString())
      ? substring(0, length - pattern.toString().length)
      : this;

  String removeSurrounding(Pattern pattern) =>
      removePrefix(pattern).removeSuffix(pattern);

  String replaceBefore(Pattern pattern, String replacement) => indexOf(pattern)
      .let((idx) => idx == -1 ? this : replaceRange(0, idx, replacement));

  String replaceAfter(Pattern pattern, String replacement) =>
      indexOf(pattern).let((idx) => idx == -1
          ? this
          : replaceRange(idx + pattern.toString().length, length, replacement));

  String replaceAfterLast(Pattern pattern, String replacement) =>
      lastIndexOf(pattern).let((idx) => idx == -1
          ? this
          : replaceRange(idx + pattern.toString().length, length, replacement));

  String replaceBeforeLast(Pattern pattern, String replacement) =>
      lastIndexOf(pattern)
          .let((idx) => idx == -1 ? this : replaceRange(0, idx, replacement));

  List<String> lines() => split('\n').toList();

  String drop(int n) => substring(n);

  String dropLast(int n) => substring(0, length - n);

  String filter(bool Function(String) block) {
    var ret = '';
    for (var i = 0; i < length; i++) {
      if (block(this[i])) {
        ret += this[i];
      }
    }
    return ret;
  }

  String filterIndexed(bool Function(int idx, String str) block) {
    var ret = '';
    for (var i = 0; i < length; i++) {
      if (block(i, this[i])) {
        ret += this[i];
      }
    }
    return ret;
  }

  String filterNot(bool Function(String) block) {
    var ret = '';
    for (var i = 0; i < length; i++) {
      if (!block(this[i])) {
        ret += this[i];
      }
    }
    return ret;
  }

  String reversed() {
    var ret = '';
    for (var i = 0; i < length; i++) {
      ret = this[i] + ret;
    }
    return ret;
  }

  List<String> toList() {
    var ret = <String>[];
    for (var i = 0; i < length; i++) {
      ret.add(this[i]);
    }
    return ret;
  }

  List<T> map<T>(T Function(String) block) {
    var ret = <T>[];
    for (var i = 0; i < length; i++) {
      ret.add(block(this[i]));
    }
    return ret;
  }

  List<T> mapIndexed<T>(T Function(int idx, String s) block) {
    var ret = <T>[];
    for (var i = 0; i < length; i++) {
      ret.add(block(i, this[i]));
    }
    return ret;
  }

  void forEach(void Function(String) block) {
    for (var i = 0; i < length; i++) {
      block(this[i]);
    }
  }

  void forEachIndexed(void Function(int idx, String s) block) {
    for (var i = 0; i < length; i++) {
      block(i, this[i]);
    }
  }

  String reduce(String Function(String acc, String s) block) {
    var accumulator = this[0];
    for (var i = 1; i < length; i++) {
      accumulator = block(accumulator, this[i]);
    }
    return accumulator;
  }

  String reduceIndexed(String Function(int idx, String acc, String s) block) {
    var accumulator = this[0];
    for (var i = 1; i < length; i++) {
      accumulator = block(i, accumulator, this[i]);
    }
    return accumulator;
  }

  int toInt() => int.parse(this);

  double toDouble() => double.parse(this);

  bool toBool() => toLowerCase() == 'true';

  DateTime toDateTime() => DateTime.parse(this);

  // ktor
  String base64encode() => base64.encode(utf8.encode(this));

  String base64decode() => utf8.decode(base64.decode(this));

  List<int> toIntList() => map((it) => it.codeUnitAt(0));

  // swift
  String lastPathPart() => substringAfterLast('/');

  String getPathDirectory() =>
      substringBeforeLast('/').let((it) => it == '' ? '/' : it);

  // rarnu
  String toJsonEncoded() =>
      replaceAll('\\', '\\\\').replaceAll('\n', '\\n').replaceAll('\"', '\\\"');

  String toTitleUpperCase() => substring(0, 1).toUpperCase() + substring(1);

  String appendPathPart(String part) {
    var ret = this;
    if (!ret.endsWith('/')) {
      ret += '/';
    }
    ret += part;
    return ret;
  }

  String extension() =>
      indexOf('.').let((idx) => idx == -1 ? '' : substringAfterLast('.'));

  String replaceTag(String tag, String Function() block) =>
      replaceAll(tag, block());

  String skipEmptyLine() =>
      lines().filterNot((it) => it.trim() == '').joinToString('\n');

  Pair<String, String> toPair() =>
      split('=').mapL((it) => it.trim()).let((it) => it[0].to(it[1]));

  void save(File f) => f.writeAsStringSync(this);

  File asFileWriteText(String s) {
    Directory(substringBeforeLast('/')).also((it) {
      if (!it.existsSync()) it.createSync(recursive: true);
    });
    return File(this).also((it) {
      it.writeAsStringSync(s);
    });
  }

  String asFileReadText() =>
      File(this).let((it) => it.existsSync() ? it.readAsStringSync() : '');

  void asFileMkdirs() => Directory(this).let((it) {
        if (!it.existsSync()) it.createSync(recursive: true);
      });

  File asFile() => File(this);

  //rarnu
  String hashWith({String alg = 'md5'}) {
    var content = Utf8Encoder().convert(this);
    Digest digest;
    switch (alg.toLowerCase()) {
      case 'sha1':
        digest = sha1.convert(content);
        break;
      case 'sha256':
        digest = sha256.convert(content);
        break;
      case 'sha512':
        digest = sha512.convert(content);
        break;
      default:
        digest = md5.convert(content);
        break;
    }
    return hex.encode(digest.bytes);
  }

  String get md5sha1 => hashWith(alg: 'MD5') + hashWith(alg: 'SHA1');

  Map<String, String> toMap() =>
      split('&').mapL((s) => s.split('=').let((i) => i[0].to(i[1]))).toMap();

  Map<String, String> toCookieMap() => split(';')
      .mapL((s) => s.trim().split('=').let((i) => i[0].to(i[1])))
      .toMap();

  RegExp asRegExp(
          {bool multiLine = false,
          bool caseSensitive = true,
          bool unicode = false,
          bool dotAll = false}) =>
      RegExp(this);

  Iterable<RegExpMatch> match(String pattern, [int start = 0]) =>
      RegExp(pattern).allMatches(this, start);
}
