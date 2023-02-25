import 'package:radix_router/src/extensions/string.dart';

import 'enum/node_type.dart';
import 'enum/parametric_node_type.dart';

class Node<T> {
  final String pathSection;
  T? value;
  final Map<String, Node<T>> staticChildNodes = {};
  final List<Node<T>> regExpParametricChildNodes = [];
  Node<T>? nonRegExpParametricChild;
  Node<T>? wildcardChild;
  final Node<T>? parentNode;

  Node({
    required this.pathSection,
    this.value,
    this.nonRegExpParametricChild,
    this.wildcardChild,
    this.parentNode,
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
    required Iterable<Node<T>> childNodes,
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
    stringBuffer.write('{"$pathSection": {');
    stringBuffer.write('"value": ${value is! num ? '"$value"' : value}, ');
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
      '"nonRegExpParametricChild": $nonRegExpParametricChild, "wildcardChild": $wildcardChild, "parentNode": ${parentNode == null ? null : '"${parentNode!.pathSection}"}}'}',
    );
    return stringBuffer.toString();
  }
}
