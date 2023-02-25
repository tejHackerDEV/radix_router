class Result<T> {
  final T value;
  final Map<String, String> pathParameters;
  final Map<String, dynamic> queryParameters;

  Result({
    required this.value,
    required this.pathParameters,
    required this.queryParameters,
  });

  @override
  String toString() {
    return '{"value": $value, "pathParameters": $pathParameters, "queryParameters": $queryParameters}';
  }
}
