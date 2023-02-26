import 'dart:convert';

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
    Iterable<T>? middlewares,
  }) {
    _trees[method] ??= Node(pathSection: '/');
    Node<T> currentNode = _trees[method]!;

    final pathSections = path.decodePath.sections;
    for (int i = 0; i < pathSections.length; ++i) {
      final pathSection = pathSections[i];
      switch (pathSection.nodeType) {
        case NodeType.static:
          currentNode = currentNode.staticChildNodes[pathSection] ??= Node<T>(
            pathSection: pathSection,
            middlewares: middlewares,
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
                final nodeToInsert = Node<T>(
                  pathSection: pathSection,
                  middlewares: middlewares,
                  parentNode: currentNode,
                );
                currentNode.regExpParametricChildNodes.add(nodeToInsert);
                nodeInsertedAlready = nodeToInsert;
              }
              currentNode = nodeInsertedAlready;
              break;
            case ParametricNodeType.nonRegExp:
              if (currentNode.nonRegExpParametricChild != null) {
                final pathSectionAlreadyPresent =
                    currentNode.nonRegExpParametricChild!.pathSection;
                if (pathSection != pathSectionAlreadyPresent) {
                  // pathSection that we want to insert is not equal to the
                  // pathSectionAlreadyPresent, so throw an error
                  throw AssertionError(
                    'Invalid pathSection detected. Found $pathSection instead of $pathSectionAlreadyPresent. This will happen if any route is already registered & startsWith ${pathSections.take(i).join('/')}/$pathSectionAlreadyPresent',
                  );
                }
              }
              currentNode = currentNode.nonRegExpParametricChild ??= Node<T>(
                pathSection: pathSection,
                middlewares: middlewares,
                parentNode: currentNode,
              );
              break;
          }
          break;
        case NodeType.wildcard:
          currentNode = currentNode.wildcardChild ??= Node<T>(
            pathSection: pathSection,
            middlewares: middlewares,
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

  Result<T>? lookup({
    required HttpMethod method,
    required String path,
    bool shouldReturnParentMiddlewares = false,
  }) {
    Node<T>? currentNode = _trees[method];
    if (currentNode == null) {
      return null;
    }

    final Map<String, String> pathParameters = {};
    final List<T> middlewares = [];
    final decodedPath = path.decodePath;
    currentNode = _lookup(
      pathSections: decodedPath.sections,
      currentNode: currentNode,
      pathParameters: pathParameters,
      middlewares: middlewares,
    );

    final value = currentNode?.value;
    if (value == null) {
      return null;
    }
    return Result(
      value: value,
      pathParameters: pathParameters,
      queryParameters:
          decodedPath.queryString?.extractQueryParameters(encoding: utf8) ?? {},
      middlewares: !shouldReturnParentMiddlewares
          ? currentNode?.middlewares
          : middlewares,
    );
  }

  Node<T>? _lookup({
    required Iterable<String> pathSections,
    required Node<T>? currentNode,
    required Map<String, String> pathParameters,
    required List<T> middlewares,
  }) {
    if (pathSections.isEmpty) {
      // if empty pathSections passed throw StateError
      throw StateError("No pathSections");
    }

    final pathSection = pathSections.first;
    Node<T>? tempNode = currentNode?.staticChildNodes[pathSection];
    if (tempNode != null) {
      middlewares.addAll(tempNode.middlewares ?? []);
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
        middlewares: middlewares,
      );
    }

    // not found in static route, so look in parametricChildNodes
    // at first look in regExpParametricChildNodes
    for (int j = 0;
        j < (currentNode?.regExpParametricChildNodes.length ?? 0);
        ++j) {
      tempNode = currentNode!.regExpParametricChildNodes[j];
      // it is an regExp one, so check regExp matches the pathSection
      if (!tempNode.parameterRegExp!.hasMatch(pathSection)) {
        // match not found, so skip the iteration
        continue;
      }
      pathParameters[tempNode.parameterName] = pathSection;
      middlewares.addAll(tempNode.middlewares ?? []);
      if (pathSections.containsOnlyOneElement) {
        // as it contains only one element, simply return it
        return tempNode;
      }
      return _lookup(
        pathSections: pathSections.skip(1),
        currentNode: tempNode,
        pathParameters: pathParameters,
        middlewares: middlewares,
      );
    }

    // notFound in regExpParametricChildNodes, so look in nonExpParametricChild
    tempNode = currentNode?.nonRegExpParametricChild;
    if (tempNode != null) {
      // it is an non-regex, so don't check anything
      pathParameters[tempNode.parameterName] = pathSection;
      middlewares.addAll(tempNode.middlewares ?? []);
      if (pathSections.containsOnlyOneElement) {
        // as it contains only one element, simply return it
        return tempNode;
      }
      return _lookup(
        pathSections: pathSections.skip(1),
        currentNode: tempNode,
        pathParameters: pathParameters,
        middlewares: middlewares,
      );
    }

    // route not found in parametricNodes so check for wildcardNode
    tempNode = currentNode;
    Node<T>? tempWildcardNode = tempNode?.wildcardChild;
    do {
      if (tempWildcardNode != null) {
        // wildcardNode found so update the pathParameters
        // with the remaining pathSections, as well as
        // clear all middlewares & add only the wildcard middlewares.
        //
        // And finally return it
        pathParameters['*'] = pathSections.join('/');
        middlewares.clear();
        middlewares.addAll(tempWildcardNode.middlewares ?? []);
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
