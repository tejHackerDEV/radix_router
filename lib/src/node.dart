import 'package:radix_router/src/extensions/iterable.dart';
import 'package:radix_router/src/extensions/string.dart';

import 'enum/node_type.dart';
import 'enum/parametric_node_type.dart';

class Node<T, S> {
  final String pathSection;
  T? value;
  final Iterable<S>? middlewares;
  final Map<String, Node<T, S>> staticChildNodes = {};
  final List<Node<T, S>> regExpParametricChildNodes = [];
  Node<T, S>? nonRegExpParametricChild;
  Node<T, S>? wildcardNode;

  Node({
    required this.pathSection,
    this.value,
    this.middlewares,
    this.nonRegExpParametricChild,
    this.wildcardNode,
  });

  NodeType get type => pathSection.nodeType;

  ParametricNodeType get parametricType {
    if (parameterRegExp == null) {
      return ParametricNodeType.nonRegExp;
    }
    return ParametricNodeType.regExp;
  }

  String get parameterName {
    if (type != NodeType.parametric) {
      throw AssertionError('$this is not a parametric path');
    }
    final index = pathSection.indexOf(':');
    return pathSection.substring(
      1,
      index == -1 ? pathSection.length - 1 : index,
    );
  }

  RegExp? get parameterRegExp {
    if (type != NodeType.parametric) {
      throw AssertionError('$this is not a parametric path');
    }
    final index = pathSection.indexOf(':');
    if (index == -1) {
      return null;
    }
    return RegExp(
      pathSection.substring(
        index + 1,
        pathSection.length - 1,
      ),
    );
  }

  StringBuffer _writeChildNodesBufferData(
    StringBuffer? stringBuffer, {
    required String title,
    required Iterable<Node<T, S>> childNodes,
    required bool shouldAddTrailingComma,
  }) {
    stringBuffer ??= StringBuffer();
    stringBuffer.write('"$title": ');
    if (childNodes.isEmpty) {
      stringBuffer.write(null);
    } else {
      stringBuffer.write('[');
      for (int i = 0; i < childNodes.length; ++i) {
        final childNode = childNodes.elementAt(i);
        stringBuffer.write(childNode);
        if (i != childNodes.length - 1) {
          stringBuffer.write(', ');
        }
      }
      stringBuffer.write(']');
    }
    if (shouldAddTrailingComma) {
      stringBuffer.write(', ');
    }
    return stringBuffer;
  }

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer
      ..write('{"$pathSection": {')
      ..write('"value": ${value is! num ? '"$value"' : value}, ')
      ..write('"middlewares": ');
    if (middlewares != null) {
      stringBuffer.write('[');
      for (int i = 0; i < middlewares!.length; ++i) {
        final middleware = middlewares!.elementAt(i);
        stringBuffer
            .write('${middleware is! num ? '"$middleware"' : middleware}');
        if (!middlewares!.isLastIteration(i)) {
          stringBuffer.write(', ');
        }
      }
      stringBuffer.write('], ');
    } else {
      stringBuffer
        ..write(null)
        ..write(', ');
    }
    _writeChildNodesBufferData(
      stringBuffer,
      title: 'staticChildNodes',
      childNodes: staticChildNodes.values,
      shouldAddTrailingComma: true,
    );
    _writeChildNodesBufferData(
      stringBuffer,
      title: 'regExpParametricChildNodes',
      childNodes: regExpParametricChildNodes,
      shouldAddTrailingComma: true,
    );
    stringBuffer.write(
      '"nonRegExpParametricChild": $nonRegExpParametricChild, "wildcardNode": $wildcardNode}}',
    );
    return stringBuffer.toString();
  }
}
