class Result<T> {
  final T value;
  final Map<String, String> pathParameters;

  Result({
    required this.value,
    required this.pathParameters,
  });

  @override
  String toString() {
    return '{"value": $value, "pathParameters": $pathParameters}';
  }
}
