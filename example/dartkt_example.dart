import 'package:dartkt/dartkt.dart';

void main() {
  var list = [1, 2, 3];
  var list2 = list.map2((it) => 'item: $it');
  var nullableList = [null, "hello", "asdff", null];
  print(nullableList);
  var removedNulls = nullableList.filterNotNull();
  print(removedNulls);
  print(list2);
}
