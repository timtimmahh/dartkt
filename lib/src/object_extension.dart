class ElseBlock<T> {
  bool condition;
  T obj;

  ElseBlock(this.condition, this.obj);

  T elseBlock(T Function(T) action) => condition ? action(obj) : obj;
}

extension KTNullableObjectExtension<T> on T? {
  T? takeIf(bool Function(T) block) => this != null && block(this!) ? this : null;

  T? takeUnless(bool Function(T) block) => this != null && !block(this!) ? this : null;
}

extension KTObjectExtension<T> on T {
  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  R let<R>(R Function(T it) block) => block(this);

  ElseBlock<T> ifBlock(bool condition, T Function(T) block) =>
      ElseBlock(condition, condition ? block(this) : this);
  T block(void Function() action) {
    action();
    return this;
  }
}
