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
      if (currentNode.type == NodeType.wildcard) {
        // if currentNode is wildcard node, then there shouldn't be any other sections
        // after the path
        throw AssertionError(
          'Wildcard should be the last section of the $path',
        );
      }

      final pathSection = pathSections[i];
      if (pathSection.isEmpty) {
        continue;
      }

      switch (pathSection.nodeType) {
        case NodeType.static:
          currentNode = currentNode.staticChildren[pathSection] ??= Node<T>(
            pathSection: pathSection,
            parentNode: currentNode,
          );
          break;
        case NodeType.parametric:
          Node<T>? nodeInsertedAlready = currentNode.parametricChildren
              .firstWhereOrNull((parametricChild) =>
                  parametricChild.pathSection == pathSection);
          if (nodeInsertedAlready == null) {
            // node in not inserted already. So insert new node
            final nodeToInsert =
                Node<T>(pathSection: pathSection, parentNode: currentNode);
            currentNode.parametricChildren.add(nodeToInsert);
            nodeInsertedAlready = nodeToInsert;
          }
          currentNode = nodeInsertedAlready;
          break;
        case NodeType.wildcard:
          currentNode = currentNode.wildcardChild ??= Node<T>(
            pathSection: pathSection,
            parentNode: currentNode,
          );
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
          // lookup in wildcardChild
          if (currentNode?.wildcardChild != null) {
            return currentNode?.wildcardChild?.value;
          }
        }
      }

      if (i == pathSections.length - 1 && tempCurrentNode?.value == null) {
        // it is last section but value not found,
        // so check if any parentNode's has any wildcardChild by backtracking
        while (true) {
          if (currentNode?.wildcardChild == null) {
            tempCurrentNode = currentNode?.parentNode;
            if (tempCurrentNode == null) {
              return null;
            }
            currentNode = tempCurrentNode;
            continue;
          }
          return currentNode?.wildcardChild?.value;
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
