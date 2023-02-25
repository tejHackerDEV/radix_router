class DecodedPath {
  final List<String> sections;
  final String? queryString;

  DecodedPath(this.sections, this.queryString);

  @override
  String toString() {
    return 'DecodedPath{sections: $sections, queryString: $queryString}';
  }
}
