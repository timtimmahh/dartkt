Pair<F, S> pair<F, S>(F first, S second) => Pair<F, S>.of(first, second);

class Pair<T, U> implements MapEntry<T, U> {
  Pair(this.left, this.right);

  final T left;
  final U right;

  factory Pair.of(T first, U second) => Pair(first, second);

  @override
  String toString() => 'Pair[$left, $right]';

  List<R?> toList<R>(
          [R Function(T first)? mapFirst, R Function(U second)? mapSecond]) =>
      [
        mapFirst != null ? mapFirst(left) : (T is R ? left as R : null),
        mapSecond != null ? mapSecond(right) : (U is R ? right as R : null)
      ];

  @override
  T get key => left;

  @override
  U get value => right;
}

Triple<F, S, T> triple<F, S, T>(F first, S second, T third) =>
    Triple.of(first, second, third);

class Triple<A, B, C> {
  Triple(this.first, this.second, this.third);

  final A first;
  final B second;
  final C third;

  factory Triple.of(A first, B second, C third) => Triple(first, second, third);

  @override
  String toString() => 'Triple[$first, $second, $third]';

  List<R?> toList<R>(
          [R Function(A first)? mapFirst,
          R Function(B second)? mapSecond,
          R Function(C third)? mapThird]) =>
      [
        mapFirst != null ? mapFirst(first) : (A is R ? first as R : null),
        mapSecond != null ? mapSecond(second) : (B is R ? second as R : null),
        mapThird != null ? mapThird(third) : (C is R ? third as R : null),
      ];
}
