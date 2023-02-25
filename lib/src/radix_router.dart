import 'package:radix_router/src/extensions/iterable.dart';
import 'package:radix_router/src/extensions/string.dart';

import 'enum/http_method.dart';
import 'enum/node_type.dart';
import 'enum/parametric_node_type.dart';
import 'node.dart';
import 'result.dart';

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
          currentNode = currentNode.staticChildNodes[pathSection] ??= Node<T>(
            pathSection: pathSection,
            parentNode: currentNode,
          );
          break;
        case NodeType.parametric:
          switch (pathSection.parametricNodeType) {
            case ParametricNodeType.regExp:
              Node<T>? nodeInsertedAlready = currentNode
                  .regExpParametricChildNodes
                  .firstWhereOrNull((parametricChild) =>
                      parametricChild.pathSection == pathSection);
              if (nodeInsertedAlready == null) {
                // node in not inserted already. So insert new node
                final nodeToInsert =
                    Node<T>(pathSection: pathSection, parentNode: currentNode);
                currentNode.regExpParametricChildNodes.add(nodeToInsert);
                nodeInsertedAlready = nodeToInsert;
              }
              currentNode = nodeInsertedAlready;
              break;
            case ParametricNodeType.nonRegExp:
              currentNode = currentNode.nonRegExpParametricChild ??= Node<T>(
                pathSection: pathSection,
                parentNode: currentNode,
              );
              break;
          }
          break;
        case NodeType.wildcard:
          currentNode = currentNode.wildcardChild ??= Node<T>(
            pathSection: pathSection,
            parentNode: currentNode,
          );

          if (!pathSections.isLastIteration(i)) {
            // if currentNode is wildcard node, then there shouldn't
            // be any other sections after the path
            throw AssertionError(
              'Wildcard should be the last section of the $path',
            );
          }
          break;
      }
    }
    if (currentNode.value != null) {
      throw AssertionError('$path is already registered for $method');
    }
    currentNode.value = value;
  }

  Result<T>? lookup({required HttpMethod method, required String path}) {
    Node<T>? currentNode = _trees[method];
    if (currentNode == null) {
      return null;
    }

    final Map<String, String> pathParameters = {};
    currentNode = _lookup(
      pathSections: path.split('/')
        // remove empty pathSections otherwise their will be issues while lookup
        ..removeWhere((pathSection) => pathSection.trim().isEmpty),
      currentNode: currentNode,
      pathParameters: pathParameters,
    );

    final value = currentNode?.value;
    if (value == null) {
      return null;
    }
    return Result(value: value, pathParameters: pathParameters);
  }

  Node<T>? _lookup({
    required Iterable<String> pathSections,
    required Node<T>? currentNode,
    required Map<String, String> pathParameters,
  }) {
    if (pathSections.isEmpty) {
      // if empty pathSections passed throw StateError
      throw StateError("No pathSections");
    }

    final pathSection = pathSections.first;
    Node<T>? tempNode = currentNode?.staticChildNodes[pathSection];
    if (tempNode != null) {
      if (pathSections.containsOnlyOneElement) {
        // as it contains only one element, simply return it
        return tempNode;
      }
      // still some pathSections are remaining so keep looking forward
      // with the found Node
      return _lookup(
        pathSections: pathSections.skip(1),
        currentNode: tempNode,
        pathParameters: pathParameters,
      );
    }

    // not found in static route, so look in parametricChildNodes
    // at first look in regExpParametricChildNodes
    for (int j = 0;
        j < (currentNode?.regExpParametricChildNodes.length ?? 0);
        ++j) {
      final tempParametricNode = currentNode!.regExpParametricChildNodes[j];
      final Map<String, String> parametricPathParameters = {};
      // it is an regExp one, so check regExp matches the pathSection
      if (!tempParametricNode.parameterRegExp!.hasMatch(pathSection)) {
        // match not found, so skip the iteration
        continue;
      }
      parametricPathParameters[tempParametricNode.parameterName] = pathSection;
      if (pathSections.containsOnlyOneElement) {
        // as it contains only one element, simply return it
        // by adding parametricPathParameters to pathParameters
        pathParameters.addAll(parametricPathParameters);
        return tempParametricNode;
      }
      final resultNode = _lookup(
        pathSections: pathSections.skip(1),
        currentNode: tempParametricNode,
        pathParameters: parametricPathParameters,
      );
      // add parametricPathParameters to pathParameters,
      // so that the final pathParameters will contain all combinations
      pathParameters.addAll(parametricPathParameters);
      return resultNode;
    }

    // notFound in regExpParametricChildNodes, so look in nonExpParametricChild
    tempNode = currentNode?.nonRegExpParametricChild;
    if (tempNode != null) {
      final Map<String, String> parametricPathParameters = {};
      // it is an non-regex, so don't check anything
      parametricPathParameters[tempNode.parameterName] = pathSection;
      if (pathSections.containsOnlyOneElement) {
        // as it contains only one element, simply return it
        // by adding parametricPathParameters to pathParameters
        pathParameters.addAll(parametricPathParameters);
        return tempNode;
      }
      final resultNode = _lookup(
        pathSections: pathSections.skip(1),
        currentNode: tempNode,
        pathParameters: parametricPathParameters,
      );
      // add parametricPathParameters to pathParameters,
      // so that the final pathParameters will contain all combinations
      pathParameters.addAll(parametricPathParameters);
      return resultNode;
    }

    // route not found in parametricNodes so check for wildcardNode
    tempNode = currentNode;
    Node<T>? tempWildcardNode = tempNode?.wildcardChild;
    do {
      if (tempWildcardNode != null) {
        // wildcardNode found so update the pathParameters
        // with the remaining pathSections & return it.
        pathParameters['*'] = pathSections.join('/');
        return tempWildcardNode;
      }
      tempNode = tempNode?.parentNode;
      tempWildcardNode = tempNode?.wildcardChild;
    } while (tempNode != null);
    return null;
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
