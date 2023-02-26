extension IterableExtension<T> on Iterable<T> {
  bool get containsOnlyOneElement => length == 1;

  bool isLastIteration(int i) => length - 1 == i;
}
