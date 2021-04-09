typedef Pair<F, S> = KTPair<F, S>;

KTPair<F, S> pair<F, S>(F first, S second) => KTPair<F, S>.of(first, second);

class KTPair<T, U> {
  KTPair(this.left, this.right);

  final T left;
  final U right;

  factory KTPair.of(T first, U second) => KTPair(first, second);

  @override
  String toString() => 'Pair[$left, $right]';

  List<R?> toList<R>(
          [R Function(T first)? mapFirst, R Function(U second)? mapSecond]) =>
      [
        mapFirst != null ? mapFirst(left) : (T is R ? left as R : null),
        mapSecond != null ? mapSecond(right) : (U is R ? right as R : null)
      ];
}

typedef Triple<F, S, T> = KTTriple<F, S, T>;

KTTriple<F, S, T> triple<F, S, T>(F first, S second, T third) =>
    KTTriple.of(first, second, third);

class KTTriple<A, B, C> {
  KTTriple(this.first, this.second, this.third);

  final A first;
  final B second;
  final C third;

  factory KTTriple.of(A first, B second, C third) =>
      KTTriple(first, second, third);

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
