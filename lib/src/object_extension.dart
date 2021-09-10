import 'pair_extension.dart';

class ElseBlock<T> {
  bool condition;
  T obj;

  ElseBlock(this.condition, this.obj);

  T elseDo(T Function(T it) action) => condition ? action(obj) : obj;
}

extension KTNullableObjectExtension<T> on T? {
  T? takeIf(bool Function(T) block) =>
      this != null && block(this!) ? this : null;

  T? takeUnless(bool Function(T) block) =>
      this != null && !block(this!) ? this : null;

  T? apply(void Function(T it) block) => also(block);

  T? also(void Function(T it) block) {
    if (this != null) block(this!);
    return this;
  }

  R? let<R>(R Function(T it) block) => this != null ? block(this!) : null;

  Pair<T?, S?> to<S>(S? second) => Pair<T?, S?>.of(this, second);

  Triple<T?, S?, V?> toAll<S, V>(S? second, V? third) =>
      Triple<T?, S?, V?>.of(this, second, third);
}

extension KTObjectExtension<T> on T {
  T apply(void Function(T it) block) => also(block);

  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  R let<R>(R Function(T it) block) => block(this);

  ElseBlock<T> doIf(bool condition, T Function(T) block) =>
      ElseBlock(condition, condition ? block(this) : this);

  Pair<T, S> to<S>(S second) => Pair<T, S>.of(this, second);

  Triple<T, S, V> toAll<S, V>(S second, V third) =>
      Triple<T, S, V>.of(this, second, third);
}
