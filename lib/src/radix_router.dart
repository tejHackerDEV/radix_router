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

    try {
      currentNode = _lookup(
        pathSections: path.split('/')
          // remove empty pathSections otherwise their will be issues while lookup
          ..removeWhere((pathSection) => pathSection.trim().isEmpty),
        currentNode: currentNode,
      );
    } on StateError {
      currentNode = null;
    }
    return currentNode?.value;
  }

  Node<T>? _lookup({
    required Iterable<String> pathSections,
    required Node<T>? currentNode,
  }) {
    if (pathSections.isEmpty) {
      // if empty pathSections passed throw StateError
      throw StateError("No pathSections");
    }

    for (int i = 0; i < pathSections.length; ++i) {
      final pathSection = pathSections.elementAt(i);
      if (pathSection.isEmpty) {
        continue;
      }
      Node<T>? tempCurrentNode = currentNode?.staticChildren[pathSection];
      if (tempCurrentNode == null) {
        // lookup in parametric children
        Node<T>? nonRegExpResultNode;
        Node<T>? regExpResultNode;
        for (int j = 0;
            j < (currentNode?.parametricChildren.length ?? 0);
            ++j) {
          final currentParametricNode = currentNode!.parametricChildren[j];
          final regExp = currentParametricNode.parameterRegExp;

          // Try to lookup for the reaming path under the currentParametricNode,
          // if the result found then set it, else discard the currentParametricNode
          // & keep looking forward
          final remainingPathSections = pathSections.skip(i + 1);
          bool doesRegexMatched = regExp?.hasMatch(pathSection) == true;
          Node<T>? resultNode;
          void setResultNode() {
            if (regExp == null) {
              nonRegExpResultNode = resultNode;
              return;
            }
            regExpResultNode = resultNode;
          }

          if (regExp == null || doesRegexMatched) {
            try {
              resultNode = _lookup(
                pathSections: remainingPathSections,
                currentNode: currentParametricNode,
              );
            } on StateError {
              resultNode = currentParametricNode;
            }

            setResultNode();
          }
        }

        // If any parametricNode is set then simply return it without going further.
        // Also regExpParametricNode has higher precedence
        // over normalParametricNode which doesn't have any regExp
        if (regExpResultNode?.value != null) {
          return regExpResultNode;
        } else if (nonRegExpResultNode?.value != null) {
          return nonRegExpResultNode;
        }

        if (tempCurrentNode == null) {
          // lookup in wildcardChild
          if (currentNode?.wildcardChild != null) {
            return currentNode?.wildcardChild;
          }
        }
      }

      if (pathSections.isAtLastIteration(i) && tempCurrentNode?.value == null) {
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
          return currentNode?.wildcardChild;
        }
      }

      currentNode = tempCurrentNode;
    }

    return currentNode;
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
