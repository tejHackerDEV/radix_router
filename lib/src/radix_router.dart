import 'enum/http_method.dart';
import 'node.dart';

class RadixRouter<T> {
  final Map<HttpMethod, Node<T>> _trees = {};

  void put({
    required HttpMethod method,
    required String path,
    required T value,
  }) {
    _trees[method] ??= Node(pathSection: '/');
    Node<T> currentNode = _trees[method]!;

    final pathSections = path.split('/');
    for (int i = 0; i < pathSections.length; ++i) {
      final pathSection = pathSections[i];
      if (pathSection.isEmpty) {
        continue;
      }
      currentNode =
          currentNode.children[pathSection] ??= Node(pathSection: pathSection);
    }
    if (currentNode.value != null) {
      throw AssertionError('$path is already registered for $method');
    }
    currentNode.value = value;
  }

  T? lookup({required HttpMethod method, required String path}) {
    Node<T>? currentNode = _trees[method];
    if (currentNode == null) {
      return null;
    }

    final pathSections = path.split('/');
    for (int i = 0; i < pathSections.length; ++i) {
      final pathSection = pathSections[i];
      if (pathSection.isEmpty) {
        continue;
      }
      currentNode = currentNode?.children[pathSection];
      if (currentNode == null) {
        return null;
      }
    }
    return currentNode?.value;
  }

  void clear() {
    _trees.clear();
  }

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('{');
    final treeEntries = _trees.entries;
    for (int i = 0; i < treeEntries.length; ++i) {
      final treeEntry = treeEntries.elementAt(i);
      stringBuffer.write('"${treeEntry.key}"');
      stringBuffer.write(': ');
      stringBuffer.write(treeEntry.value);
      if (i != treeEntries.length - 1) {
        stringBuffer.write(', ');
      }
    }
    stringBuffer.write('}');
    return stringBuffer.toString();
  }
}
