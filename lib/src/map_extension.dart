import 'dart:collection';

import 'list_extension.dart';

Map<K, V> emptyMap<K, V>() => <K, V>{};

extension KTMapExtension<K, V> on Map<K, V> {
  bool isKeyType<T>() => K == T;

  bool isValueType<T>() => V == T;

  // kotlin
  List<MapEntry<K, V>> toList() {
    var ret = <MapEntry<K, V>>[];
    forEach((k, v) => ret.add(MapEntry(k, v)));
    return ret;
  }

  List<R> mapToList<R>(R Function(K key, V value) block) {
    var ret = <R>[];
    forEach((k, v) => ret.add(block(k, v)));
    return ret;
  }

  void forEachEntry(void Function(K key, V value) block) =>
      forEach((k, v) => block(k, v));

  bool all(bool Function(K key, V value) block) {
    if (isEmpty) return false;
    var ret = true;
    forEachEntry((key, value) {
      if (!block(key, value)) ret = false;
    });
    return ret;
  }

  bool any(bool Function(K key, V value) block) {
    if (isEmpty) return false;
    var ret = false;
    forEachEntry((key, value) {
      if (block(key, value)) ret = true;
    });
    return ret;
  }

  int count(bool Function(K key, V value) block) {
    var ret = 0;
    forEachEntry((key, value) {
      if (block(key, value)) ret++;
    });
    return ret;
  }

  bool none(bool Function(K key, V value) block) {
    if (isEmpty) return true;
    var ret = true;
    forEachEntry((key, value) {
      if (block(key, value)) ret = false;
    });
    return ret;
  }

  Map<K, V> filterKeys(bool Function(K key) block) {
    var ret = <K, V>{};
    forEachEntry((key, value) {
      if (block(key)) ret[key] = value;
    });
    return ret;
  }

  Map<K, V> filterValues(bool Function(V value) block) {
    var ret = <K, V>{};
    forEachEntry((key, value) {
      if (block(value)) ret[key] = value;
    });
    return ret;
  }

  Map<K, V> filter(bool Function(K key, V value) block) {
    var ret = <K, V>{};
    forEachEntry((key, value) {
      if (block(key, value)) ret[key] = value;
    });
    return ret;
  }

  Map<K, V> filterNot(bool Function(K key, V value) block) {
    var ret = <K, V>{};
    forEachEntry((key, value) {
      if (!block(key, value)) ret[key] = value;
    });
    return ret;
  }

  V? get first => this[keys.first];

  V? get last => this[keys.last];

  void add(Map<K, V> map) => map.forEach((k, v) => this[k] = v);

  void minus(Map<K, V> map) => removeWhere((k, v) => map[k] == v);

  Map<K, V> filterTo<M extends Map<K, V>>(
      M dest, bool Function(K key, V value) block) {
    forEachEntry((key, value) {
      if (block(key, value)) {
        dest[key] = value;
      }
    });
    return dest;
  }

  Map<K, V> filterNotTo<M extends Map<K, V>>(
      M dest, bool Function(K key, V value) block) {
    forEachEntry((key, value) {
      if (!block(key, value)) {
        dest[key] = value;
      }
    });
    return dest;
  }

  Map<K, V> filterValuesTo<M extends Map<K, V>>(
      M dest, bool Function(V value) block) {
    forEachEntry((key, value) {
      if (block(value)) {
        dest[key] = value;
      }
    });
    return dest;
  }

  Map<K2, V2> mapTo<K2, V2, C extends Map<K2, V2>>(
      C dest, MapEntry<K2, V2> Function(K key, V value) block) {
    forEachEntry((key, value) {
      var item = block(key, value);
      dest[item.key] = item.value;
    });
    return dest;
  }

  List<R> mapToListTo<R, C extends List<R>>(
      C dest, R Function(K key, V value) block) {
    forEachEntry((key, value) {
      dest.add(block(key, value));
    });
    return dest;
  }

  Map<K2, V2> mapKeysTo<K2, V2, C extends Map<K2, V2>>(
      C dest, MapEntry<K2, V2> Function(K key) block) {
    forEachEntry((key, value) {
      var item = block(key);
      dest[item.key] = item.value;
    });
    return dest;
  }

  Map<K2, V> mapKeys<K2>(K2 Function(K key) block) =>
      map((key, value) => MapEntry(block(key), value));

  List<R> mapKeysToListTo<R, C extends List<R>>(
      C dest, R Function(K key) block) {
    forEach((key, value) {
      dest.add(block(key));
    });
    return dest;
  }

  Map<K2, V2> mapValuesTo<K2, V2, C extends Map<K2, V2>>(
      C dest, MapEntry<K2, V2> Function(V value) block) {
    forEachEntry((key, value) {
      var item = block(value);
      dest[item.key] = item.value;
    });
    return dest;
  }

  Map<K, V2> mapValues<V2>(V2 Function(V value) block) =>
      map((key, value) => MapEntry(key, block(value)));

  List<R> mapValuesToListTo<R, C extends List<R>>(
      C dest, R Function(V value) block) {
    forEach((key, value) {
      dest.add(block(value));
    });
    return dest;
  }

  LinkedHashMap<K, V> sortBy(
          [int Function(MapEntry<K, V> first, MapEntry<K, V> second)?
              compare]) =>
      compare == null
          ? sortByKey()
          : LinkedHashMap.fromEntries(keys
              .toList()
              .sortBy((K first, K second) => compare(
                  MapEntry(first, this[first]!),
                  MapEntry(second, this[second]!)))
              .map((e) => MapEntry(e, this[e]!)));

  LinkedHashMap<K, V> sortByDescending(
          [int Function(MapEntry<K, V> first, MapEntry<K, V> second)?
              compare]) =>
      sortBy(
          compare != null ? (first, second) => compare(second, first) : null);

  LinkedHashMap<K, V> sortByKey([int Function(K first, K second)? compare]) =>
      LinkedHashMap.fromEntries(
          keys.toList().sortBy(compare).map((e) => MapEntry(e, this[e]!)));

  LinkedHashMap<K, V> sortByValue([int Function(V first, V second)? compare]) =>
      LinkedHashMap.fromEntries(keys
          .toList()
          .sortBy(compare != null
              ? (first, second) => compare(this[first]!, this[second]!)
              : null)
          .map((e) => MapEntry(e, this[e]!)));

  String toCookieString() => mapToList((key, value) => '$key=$value').join(';');
}

extension KTDynamicMapExtension<K> on Map<K, dynamic> {
  V? getAs<V>(K key, {V Function(dynamic value)? converter}) {
    dynamic value = this[key];
    if (value is V) {
      return value;
    }
    if (converter == null && value is String) {
      switch (V) {
        case int:
          converter = (value) => int.parse(value as String) as V;
          break;
        case double:
          converter = (value) => double.parse(value as String) as V;
          break;
      }
    }
    return converter?.call(value);
  }
}
