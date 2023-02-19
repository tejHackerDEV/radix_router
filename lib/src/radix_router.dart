import 'package:radix_router/src/extensions/iterable.dart';
import 'package:radix_router/src/extensions/string.dart';

import 'enum/http_method.dart';
import 'enum/node_type.dart';
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

      switch (pathSection.nodeType) {
        case NodeType.static:
          currentNode = currentNode.staticChildren[pathSection] ??=
              Node<T>(pathSection: pathSection);
          break;
        case NodeType.parametric:
          Node<T>? nodeInsertedAlready = currentNode.parametricChildren
              .firstWhereOrNull((parametricChild) =>
                  parametricChild.pathSection == pathSection);
          if (nodeInsertedAlready == null) {
            // node in not inserted already. So insert new node
            final nodeToInsert = Node<T>(pathSection: pathSection);
            currentNode.parametricChildren.add(nodeToInsert);
            nodeInsertedAlready = nodeToInsert;
          }
          currentNode = nodeInsertedAlready;
          break;
      }
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
      Node<T>? tempCurrentNode = currentNode?.staticChildren[pathSection];
      if (tempCurrentNode == null) {
        // lookup in parametric children
        tempCurrentNode = currentNode?.parametricChildren.firstWhereOrNull(
          (parametricChild) => parametricChild.parameterName.isNotEmpty,
        );
        if (tempCurrentNode == null) {
          return null;
        }
      }
      currentNode = tempCurrentNode;
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
