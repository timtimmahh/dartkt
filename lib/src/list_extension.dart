import 'bool_extension.dart';
import 'pair_extension.dart';

Iterable<T> emptyIterable<T>() => Iterable.empty();

List<T> emptyList<T>() => List<T>.empty();

extension KTNumIterableExtension on Iterable<num> {
  double average() {
    var sum = 0.0;
    var count = 0;
    for (var e in this) {
      sum += e;
      ++count;
    }
    return count == 0 ? double.nan : sum / count;
  }
}

extension KTDynamicIterableExtension on Iterable<dynamic> {
  Iterable<R> filterIsInstance<R>() => whereType<R>();
}

extension KTIterableExtension<T> on Iterable<T> {
  bool all(bool Function(T it) predicate) {
    if (isEmpty) return false;
    for (var item in this) {
      if (!predicate(item)) {
        return false;
      }
    }
    return true;
  }

  bool any(bool Function(T it) predicate) {
    if (isEmpty) return false;
    for (var item in this) {
      if (predicate(item)) {
        return true;
      }
    }
    return false;
  }

  Map<K, V> associate<K, V>(Pair<K, V> Function(T it) transform) =>
      map(transform).toMap();

  Map<K, V> associateBy<K, V>(K Function(T it) keySelector,
          [V Function(T it)? valueTransform]) =>
      associate((it) =>
          Pair.of(keySelector(it), valueTransform?.call(it) ?? it as V));

  Map<T, V> associateWith<V>(V Function(T it) valueSelector) =>
      map((e) => Pair.of(e, valueSelector(e))).toMap();

  List<List<T>> chunked(int size) {
    var result = <List<T>>[];
    var it = iterator;
    while (it.moveNext()) {
      var chunk = <T>[it.current];
      for (var i = 1; i < size && it.moveNext(); i++) {
        chunk.add(it.current);
      }
      result.add(chunk);
    }
    return result;
  }

  List<R> chunkedBy<R>(int size, R Function(List<T> it) transform) {
    var result = <R>[];
    var it = iterator;
    while (it.moveNext()) {
      var chunk = <T>[it.current];
      for (var i = 1; i < size && it.moveNext(); i++) {
        chunk.add(it.current);
      }
      result.add(transform(chunk));
    }
    return result;
  }

  Iterable<T> distinct() => Set.of(this);

  Iterable<T> distinctBy<K>(K Function(T it) selector) =>
      Map<K, T>.fromIterable(this, key: (it) => selector(it)).values;

  Iterable<T> drop(int n) => skip(n);

  Iterable<T> dropWhile(bool Function(T it) predicate) => skipWhile(predicate);

  Iterable<T> filter(bool Function(T it) predicate) => where(predicate);

  Iterable<T> filterNot(bool Function(T it) predicate) =>
      where((e) => !predicate(e));

  T? find(bool Function(T it) predicate) => firstWhere(predicate);

  T? findLast(bool Function(T it) predicate) => lastWhere(predicate);

  Iterable<R> flatMap<R>(Iterable<R> Function(T it) transform) =>
      expand(transform);

  R fold<R>(R initialValue, R Function(R acc, T it) combine) {
    var finalValue = initialValue;
    for (var item in this) {
      finalValue = combine(finalValue, item);
    }
    return finalValue;
  }

  Map<K, Iterable<V>> groupBy<K, V>(K Function(T it) keySelector,
      [V Function(T it)? valueTransform]) {
    var result = <K, List<V>>{};
    for (var e in this) {
      result
          .putIfAbsent(keySelector(e), () => <V>[])
          .add((valueTransform ?? (it) => it as V)(e));
    }
    return result;
  }

  bool isType<E>() => T == E;

  Iterable<R> mapIndexed<R>(R Function(int index, T it) transform) {
    var result = <R>[];
    for (var index = 0, iter = iterator; iter.moveNext();) {
      result.add(transform(index, iter.current));
    }
    return result;
  }

  Iterable<R> mapNotNull<R>(R? Function(T it) transform) =>
      map(transform).whereType<R>();

  Pair<Iterable<T>, Iterable<T>> partition(bool Function(T it) predicate) {
    final parts =
        pair(List<T>.empty(growable: true), List<T>.empty(growable: true));
    for (var item in this) {
      predicate(item).chooseValue(parts.left, parts.right).add(item);
    }
    return parts;
  }

  R reduce<R>(R Function(R? acc, T it) operation) {
    R? finalValue;
    for (var item in this) {
      finalValue = operation(finalValue, item);
    }
    return finalValue!;
  }
}

extension KTIterableIterableExtension<T> on Iterable<Iterable<T>> {
  Iterable<T> flatten() => expand((element) => element);
}

extension KTIterablePairNullKeyExtension<K, V> on Iterable<Pair<K?, V>> {
  Map<K, V> toMapNotNull() => Map.fromEntries(
      map<Pair<K, V>?>((e) => e.left == null ? null : e as Pair<K, V>)
          .whereType<Pair<K, V>>());
}

extension KTIterablePairNullValueExtension<K, V> on Iterable<Pair<K, V?>> {
  Map<K, V> toMapNotNull() => Map.fromEntries(
      map<Pair<K, V>?>((e) => e.right == null ? null : e as Pair<K, V>)
          .whereType<Pair<K, V>>());
}

extension KTIterablePairNullExtension<K, V> on Iterable<Pair<K?, V?>> {
  Map<K, V> toMapNotNull() => Map.fromEntries(map<Pair<K, V>?>(
          (e) => e.left == null || e.right == null ? null : e as Pair<K, V>)
      .whereType<Pair<K, V>>());
}

extension KTIterablePairExtension<K, V> on Iterable<Pair<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

extension KTIterableNullExtension<T> on Iterable<T?> {
  Iterable<T> filterNotNull() => whereType<T>();
}

extension KTListExtension<T> on List<T> {
  List<T> append(T value) => this..add(value);

  List<T> appendAll(Iterable<T> iterable) => this..addAll(iterable);

  int count([bool Function(T it)? predicate]) {
    var ret = 0;
    for (var item in this) {
      if (predicate == null || predicate(item)) {
        ret++;
      }
    }
    return ret;
  }

  List<T> distinct() {
    var ret = <T>[];
    for (var item in this) {
      if (!ret.contains(item)) {
        ret.add(item);
      }
    }
    return ret;
  }

  List<T> distinctBy<R>(R Function(T it) selector) {
    var set = <R>{};
    var list = <T>[];
    for (var e in this) {
      var key = selector(e);
      if (set.add(key)) {
        list.add(e);
      }
    }
    return list;
  }

  List<T> drop(int n) {
    var ret = <T>[];
    for (var i = n; i < length; i++) {
      ret.add(this[i]);
    }
    return ret;
  }

  List<T> dropLast(int n) {
    var ret = <T>[];
    for (var i = 0; i < length - n; i++) {
      ret.add(this[i]);
    }
    return ret;
  }

  List<T> filter(bool Function(T it) predicate) {
    var ret = <T>[];
    for (var i = 0; i < length; i++) {
      if (predicate(this[i])) ret.add(this[i]);
    }
    return ret;
  }

  List<T> filterIndexed(bool Function(int index, T it) predicate) {
    var ret = <T>[];
    for (var i = 0; i < length; i++) {
      if (predicate(i, this[i])) ret.add(this[i]);
    }
    return ret;
  }

  List<T> filterNot(bool Function(T it) predicate) {
    var ret = <T>[];
    for (var i = 0; i < length; i++) {
      if (!predicate(this[i])) ret.add(this[i]);
    }
    return ret;
  }

  C filterTo<C extends List<T>>(C dest, bool Function(T) block) {
    for (var item in this) {
      if (block(item)) {
        dest.add(item);
      }
    }
    return dest;
  }

  C filterIndexedTo<C extends List<T>>(
      C dest, bool Function(int idx, T item) block) {
    for (var i = 0; i < length; i++) {
      if (block(i, this[i])) {
        dest.add(this[i]);
      }
    }
    return dest;
  }

  C filterNotTo<C extends List<T>>(C dest, bool Function(T) block) {
    for (var item in this) {
      if (!block(item)) {
        dest.add(item);
      }
    }
    return dest;
  }

  // kotlin
  T? find(bool Function(T it) predicate) {
    for (var e in this) {
      if (predicate(e)) {
        return e;
      }
    }
    return null;
  }

  T? findLast(bool Function(T it) predicate) {
    for (var i = length - 1; i >= 0; i--) {
      if (predicate(this[i])) {
        return this[i];
      }
    }
    return null;
  }

  void forEachIndexed(void Function(int index, T it) action) {
    for (var i = 0; i < length; i++) {
      action(i, this[i]);
    }
  }

  int indexOfFirst(bool Function(T it) predicate) {
    var idx = -1;
    for (var i = 0; i < length; i++) {
      if (predicate(this[i])) {
        idx = i;
        break;
      }
    }
    return idx;
  }

  int indexOfLast(bool Function(T it) predicate) {
    var idx = -1;
    for (var i = length - 1; i >= 0; i--) {
      if (predicate(this[i])) {
        idx = i;
        break;
      }
    }
    return idx;
  }

  String joinToString([String sep = ',', String Function(T)? block]) {
    var str = '';
    forEach((it) {
      if (block == null) {
        str += '$it$sep';
      } else {
        str += '${block(it)}$sep';
      }
    });
    if (str.endsWith(sep)) {
      str = str.substring(0, str.length - sep.length);
    }
    return str;
  }

  C mapTo<R, C extends List<R>>(C dest, R Function(T) block) {
    for (var item in this) {
      dest.add(block(item));
    }
    return dest;
  }

  C mapIndexedTo<R, C extends List<R>>(
      C dest, R Function(int idx, T item) block) {
    for (var i = 0; i < length; i++) {
      dest.add(block(i, this[i]));
    }
    return dest;
  }

  List<R> map2<R>(R Function(T it) transform) {
    var ret = <R>[];
    for (var i = 0; i < length; i++) {
      ret.add(transform(this[i]));
    }
    return ret;
  }

  List<R> map2Indexed<R>(R Function(int index, T it) transform) {
    var ret = <R>[];
    for (var i = 0; i < length; i++) {
      ret.add(transform(i, this[i]));
    }
    return ret;
  }

  void minus(List<T> list) => removeWhere((it) => list.contains(it));

  bool none(bool Function(T it) predicate) {
    if (isEmpty) return true;
    for (var item in this) {
      if (predicate(item)) {
        return false;
      }
    }
    return true;
  }

  List<T> prepend(T value) => this..insert(0, value);

  List<T> prependAll(Iterable<T> iterable) => this..insertAll(0, iterable);

  T reduceIndexed(T Function(int index, T acc, T it) operation) {
    var accumulator = this[0];
    for (var i = 1; i < length; i++) {
      accumulator = operation(i, accumulator, this[i]);
    }
    return accumulator;
  }

  List<T> slice(int startIdx, int endIdx) => sublist(startIdx, endIdx);

  List<T> sortBy(int Function(T first, T second) selector) {
    var tmp = this;
    tmp.sort(selector);
    return tmp;
  }

  List<T> sortByDescending(int Function(T first, T second) selector) {
    var tmp = this;
    tmp.sort(selector);
    return tmp.reversed.toList();
  }

  // rarnu
  List<List<T>> toGridData([int column = 1]) {
    var ret = <List<T>>[];
    var count = 0;
    var sub = <T>[];
    for (var item in this) {
      if (count == column) {
        ret.add(sub);
        sub = <T>[];
        sub.add(item);
        count = 1;
        continue;
      }
      sub.add(item);
      count++;
    }
    if (sub.isNotEmpty) {
      ret.add(sub);
    }
    return ret;
  }

  List<String> toStringList() => map((it) => '$it').toList();
}

extension KTListListExtension<T> on List<List<T>> {
  List<T> toListData() {
    var ret = <T>[];
    forEach((l) => l.forEach((i) => ret.add(i)));
    return ret;
  }
}

extension KTStringListExtension on List<String> {
  List<String> skipEmptyLine() => filterNot((it) => it.trim() == '');
}
