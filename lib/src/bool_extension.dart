extension KTBoolExtension on bool {
  T chooseValue<T>(T valueTrue, T valueFalse) =>
      choose(() => valueTrue, () => valueFalse);

  T choose<T>(T Function() onTrue, T Function() onFalse) =>
      this ? onTrue() : onFalse();
}
