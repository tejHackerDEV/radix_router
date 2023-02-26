class Result<T, S> {
  final T value;
  final Map<String, String> pathParameters;
  final Map<String, dynamic> queryParameters;
  final Iterable<S>? middlewares;

  Result({
    required this.value,
    required this.middlewares,
    required this.pathParameters,
    required this.queryParameters,
  });

  @override
  String toString() {
    return '{"value": $value, "pathParameters": $pathParameters, "queryParameters": $queryParameters, "middlewares": $middlewares}';
  }
}
