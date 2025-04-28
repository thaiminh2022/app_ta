final class Result<T, E> {
  final T? value;
  final E? error;

  Result._(this.value, this.error);

  bool get isSuccess => value != null;
  bool get isError => error != null;

  factory Result.ok(T value) => Result._(value, null);
  factory Result.err(E error) => Result._(null, error);

  T unwrap() {
    if (isError) {
      throw Exception("Unwrap on error");
    }
    return value!;
  }

  T unwrapOr(T def) {
    if (isError) return def;
    return value!;
  }
}
