import 'dart:math';

import 'package:dartkt/dartkt.dart';

void main() {
  var list = [1, 2, 3];
  var list2 = list.map2((it) => 'item: $it');
  var nullableList = [null, "hello", "asdff", null];
  print(nullableList);
  var removedNulls = nullableList.filterNotNull();
  print(removedNulls);
  print(list2);
  var nestedIter = Iterable.generate(4, (index) {
    switch (index) {
      case 0:
        return Iterable.generate(Random().nextInt(10), (index) => index);
      case 1:
        return List.filled(10, 9);
      case 2:
        return null;
      case 3:
        return Iterable.generate(
            Random().nextInt(5), (index) => index % 2 == 1 ? null : index * 2);
      default:
        return Iterable.empty();
    }
  });
  print(nestedIter);
  print(nestedIter.flatten());
  var date = DateTime.parse('2021-08-27 19:45:00Z');
  print(date.format());
  print(date.difference(DateTime.parse('2021-08-27 18:44:30Z')).format());
}
